# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'redsquare/version'

Gem::Specification.new do |spec|
  spec.name          = "redsquare"
  spec.version       = Redsquare::VERSION
  spec.authors       = ["JC Grubbs"]
  spec.email         = ["jc.grubbs@devmynd.com"]
  spec.description   = %q{Redsquare is a server that supplies a restful interface to Redis.}
  spec.summary       = %q{Redsquare is a server that supplies a restful interface to Redis.}
  spec.homepage      = "http://github.com/thegrubbsian/redsquare"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
