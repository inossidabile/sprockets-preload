require 'helpers/boot'

describe "Circular dependency" do
  before(:all) do
    Sprockets::Preload.precompiles += ["circular/circular.js"]
  end

  after(:all) do
    Sprockets::Preload.precompiles -= ["circular/circular.js"]
  end

  it "throws" do
    expect{
      Sprockets::Preload.environment['sprockets/preload/assets']
    }.to raise_error Sprockets::Preload::CircularPreloadError
  end
end