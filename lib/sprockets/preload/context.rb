#
# Extends asset context with storage for assets to preload
#
module Sprockets
  module Preload
    module Context
      def self.included(mod)
        mod.instance_eval do
          attr_accessor :_assets_to_preload
          attr_accessor :_force_preload
        end
      end

      def preload?
        _force_preload || !Sprockets::Preload.inline
      end
    end
  end
end