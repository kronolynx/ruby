# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'stampery/version'

Gem::Specification.new do |spec|
  spec.name          = "stampery"
  spec.version       = "0.1.3"
  spec.authors       = ["Johann Ortiz"]
  spec.email         = ["johann@stampery.com"]

  spec.summary       = %q{Stampery API for Ruby}
  spec.description   = %q{Stampery API wrapper for Ruby. Notarize all your data using the blockchain!.}
  spec.homepage      = "https://github.com/stampery/ruby"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.required_ruby_version = ">= 2.0"

  spec.add_dependency "sha3", "~> 1.0", ">= 1.0.1"
  spec.add_dependency "msgpack-rpc", "~> 0.5.4"
  spec.add_dependency "bunny", '~> 2.2', ">= 2.2.2"
  spec.add_dependency "event_emitter", "~> 0.2.5"

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
end
