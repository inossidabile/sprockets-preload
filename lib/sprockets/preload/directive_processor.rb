#
# Adds `#= preload {path}` and `#= preload!` directives
#
module Sprockets
  module Preload
    module DirectiveProcessor
      def process_preload_directive(path)
        if context.content_type != 'application/javascript'
          process_require_directive path
        else 
          unless context._assets_to_preload
            process_require_directive 'sprockets/preload/load'
            context._assets_to_preload = []
          end

          context.require_asset path
          context.stub_asset path if context.preload?

          context._assets_to_preload.push path
        end
      end

      define_method :"process_preload!_directive" do
        context._force_preload = true
      end
    end
  end
end