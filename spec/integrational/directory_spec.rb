require 'helpers/boot'

describe "Self dependency" do
  before(:all) do
    Sprockets::Preload.precompiles += ["directory/directory.js"]
  end

  after(:all) do
    Sprockets::Preload.precompiles -= ["directory/directory.js"]
  end

  it "serves detached" do
    Sprockets::Preload.environment['sprockets/preload/assets'].source.should == "test1\n;\ntest2\n;\n\n"
  end

  context "inlined", inline: true do
    it "keeps inlines" do
      Sprockets::Preload.environment['directory/directory'].source.should include("test1", "test2")
      Sprockets::Preload.environment['directory/directory'].source.should include("SprocketsPreload.inline = true")
    end
  end

  context "detached", inline: false do
    it "keeps inlines" do
      Sprockets::Preload.environment['directory/directory'].source.should_not include("test1", "test2")
      Sprockets::Preload.environment['directory/directory'].source.should_not include("SprocketsPreload.inline = true")
    end
  end
end