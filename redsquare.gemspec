# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "redsquare/version"

Gem::Specification.new do |spec|
  spec.name          = "redsquare"
  spec.version       = Redsquare::VERSION
  spec.authors       = ["JC Grubbs"]
  spec.email         = ["jc@devmynd.com"]
  spec.description   = %q{A mountable/standalone HTTP interface to Redis.}
  spec.summary       = %q{A mountable/standalone HTTP interface to Redis.}
  spec.homepage      = "http://github.com/thegrubbsian/redsquare"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "redis", "~> 3.0.4"
  spec.add_dependency "sinatra", "~> 1.4.3"
  spec.add_dependency "activesupport", ">= 3.2.0"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "fakeredis"

end
