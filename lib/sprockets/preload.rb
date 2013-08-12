require 'active_support/all'
require 'sprockets'
require 'sprockets/preload/directive_processor'
require 'sprockets/preload/context'
require 'sprockets/preload/version'
require 'sprockets/preload/errors'
require 'sprockets/preload/engine' if defined?(Rails)

Sprockets::DirectiveProcessor.send :include, Sprockets::Preload::DirectiveProcessor
Sprockets::Context.send :include, Sprockets::Preload::Context

Sprockets.append_path File.expand_path('../../../assets', __FILE__)

# Pass in current environment condition to mark if loading should be stubbed
Sprockets.register_postprocessor 'application/javascript', :preload do |context, data|
  if context._assets_to_preload
    data << "SprocketsPreload.inline = true;" unless context.preload?
  end

  data
end

module Sprockets
  module Preload
    class <<self
      attr_accessor :inline
      attr_accessor :environment
      attr_accessor :precompiles
    end

    #
    # Forks circular calls protection to allow cross-tree assets interactions
    #
    def self.[](path)
      calls = Thread.current[:sprockets_circular_calls]
      Thread.current[:sprockets_circular_calls] = Set.new
      environment[path]
    ensure
      Thread.current[:sprockets_circular_calls] = calls
    end

    #
    # Iterates through all JS base-level assets of an application
    #
    def self.each_logical_path(&block)
      paths = environment.each_logical_path(*precompiles).to_a +
        precompiles.flatten.select{ |fn| Pathname.new(fn).absolute? if fn.is_a?(String) }

      paths.each do |path|
        yield(path, environment) if environment.content_type_of(path) == 'application/javascript'
      end
    end

    #
    # Recursively collects #= preload directives from given logical path
    #
    def self.collect(environment, logical_path)
      pathname = environment.resolve logical_path
      context  = environment.context_class.new(environment, logical_path, pathname)
      template = Sprockets::DirectiveProcessor.new(pathname.to_s)
      template.render(context, {})

      to_preload = context._assets_to_preload || []

      # Files marked for preloading should not have nested preload directives
      to_preload.each do |dependency|
        nesteds = collect(environment, dependency)
        if nesteds.length > 0
          raise CircularPreloadError.new("Circular preloading detected: #{dependency} -> #{nesteds.join(',')}")
        end
      end

      # Going deeper
      dependencies = context._required_paths.select do |dependency|
        dependency != pathname.to_s
      end

      dependencies.map! do |dependency|
        environment.attributes_for(dependency).logical_path
      end

      dependencies -= context._stubbed_assets.to_a + [pathname.to_s]

      dependencies.each do |dependency|
        to_preload += collect(environment, dependency)
      end

      to_preload
    end
  end
end