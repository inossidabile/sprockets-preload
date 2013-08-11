#
# Adds `#= preload {path}` and `#= preload!` directives
#
module Sprockets
  module Preload
    module DirectiveProcessor
      def process_preload_directive(path, inherit=true)
        # Other macroses like `#= preload_directory` can
        # call require on their own behalf
        process_require_directive path if inherit

        if context.content_type == 'application/javascript'
          unless context._assets_to_preload
            process_require_directive 'sprockets/preload/load'
            context._assets_to_preload = []
          end

          context.stub_asset path if context.preload?
          context._assets_to_preload.push path
        end
      end

      def process_preload_directory_directive(path=".")
        root = pathname.dirname.join(path).expand_path

        process_require_directory_directive(path).each do |pathname|
          pathname = root.join(pathname)
          if pathname.to_s == self.file
            next
          elsif context.asset_requirable?(pathname)
            process_preload_directive(context.environment.attributes_for(pathname).logical_path, false)
          end
        end
      end

      define_method :"process_preload!_directive" do
        context._force_preload = true
      end
    end
  end
end