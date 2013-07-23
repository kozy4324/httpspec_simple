# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'httpspec_simple/version'

Gem::Specification.new do |spec|
  spec.name          = "httpspec_simple"
  spec.version       = HttpspecSimple::VERSION
  spec.authors       = ["Koji NAKAMURA"]
  spec.email         = ["kozy4324@gmail.com"]
  spec.description   = %q{RSpec extension for HTTP request}
  spec.summary       = %q{RSpec extension for HTTP request}
  spec.homepage      = "https://github.com/kozy4324/httpspec_simple"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rspec", "~> 2.14.1"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
