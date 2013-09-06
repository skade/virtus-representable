# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'virtus/representable/version'

Gem::Specification.new do |spec|
  spec.name          = "virtus-representable"
  spec.version       = Virtus::Representable::VERSION
  spec.authors       = ["Florian Gilcher"]
  spec.email         = ["florian.gilcher@asquera.de"]
  spec.description   = %q{A glue layer to make working with large Virtus trees and Representable easier.}
  spec.summary       = %q{Virtus and Representable, sitting in a tree}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_dependency "virtus"
  spec.add_dependency "representable"
  spec.add_dependency "active_support"
end
