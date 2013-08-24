# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sprockets/preload/version'

Gem::Specification.new do |spec|
  spec.name          = "sprockets-preload"
  spec.version       = Sprockets::Preload::VERSION
  spec.authors       = ["Boris Staal"]
  spec.email         = ["boris@staal.io"]
  spec.description   = %q{Macros-based JS preloader for Sprockets}
  spec.summary       = %q{
    The gem extends Sprockets with helpers allowing you to
    controllably load huge JS assets with the support of
    progress tracking and localStorage caching.
  }
  spec.homepage      = "https://github.com/joosy/sprockets-preload"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "sprockets"
  spec.add_dependency "activesupport"
  spec.add_dependency "coffee-script"
end
