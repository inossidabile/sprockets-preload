#
# Defines Rails-based entries for Sprockets instance and the list of base-level assets
#
module Sprockets
  module Preload
    class Engine < ::Rails::Engine
      initializer "sprockets.preload" do |app|
        Sprockets::Preload.inline      = ::Rails.env.development?
        Sprockets::Preload.environment = app.assets
        Sprockets::Preload.precompiles = app.config.assets.precompile

        app.config.assets.precompile += ['sprockets/preload/assets.js']
      end
    end
  end
end
