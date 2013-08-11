require 'bundler/setup'

Bundler.require

Sprockets::Context.class_eval do
  def asset_path(path, options={})
    "/#{path}"
  end
end

Sprockets::Preload.precompiles = []
Sprockets.append_path File.expand_path('../assets', __FILE__)

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random:59695'

  config.before(:each) do
    Sprockets::Preload.environment = Sprockets::Environment.new
  end
end

shared_context "inlined", inline: true do
  before(:all) do
    @inline_condition = Sprockets::Preload.inline
    Sprockets::Preload.inline = true
  end

  after(:all) do
    Sprockets::Preload.inline = @inline_condition
  end
end

shared_context "detouched", inline: false do
  before(:all) do
    @inline_condition = Sprockets::Preload.inline
    Sprockets::Preload.inline = false
  end

  after(:all) do
    Sprockets::Preload.inline = @inline_condition
  end
end