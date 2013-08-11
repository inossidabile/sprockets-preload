require 'helpers/boot'

describe "Nested dependency" do
  before(:all) do
    Sprockets::Preload.precompiles += ["nested/nested.js"]
  end

  after(:all) do
    Sprockets::Preload.precompiles -= ["nested/nested.js"]
  end

  it "serves detouched" do
    Sprockets::Preload.environment['sprockets/preload/assets'].source.should == "test2\n;\n\n"
  end

  context "inlined", inline: true do
    it "keeps inlines" do
      Sprockets::Preload.environment['nested/nested'].source.should include("test1", "test2")
      Sprockets::Preload.environment['nested/nested'].source.should include("SprocketsPreload.inline = true")
    end
  end

  context "detouched", inline: false do
    it "keeps inlines" do
      Sprockets::Preload.environment['nested/nested'].source.should include("test1")
      Sprockets::Preload.environment['nested/nested'].source.should_not include("test2")
      Sprockets::Preload.environment['nested/nested'].source.should_not include("SprocketsPreload.inline = true")
    end
  end
end