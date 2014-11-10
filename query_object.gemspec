# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'query_object/version'

Gem::Specification.new do |spec|
  spec.name          = "query_object"
  spec.version       = QueryObject::VERSION
  spec.authors       = ["Dmitry Gritsay"]
  spec.email         = ["unseductable@gmail.com"]
  spec.summary       = %q{Query objects for ActiveRecord}
  spec.description   = %q{Query objects for ActiveRecord}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler",   "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec",     "~> 3.1.0"
  spec.add_development_dependency "rspec-its", "~> 1.1.0"

  spec.add_runtime_dependency     "activerecord", ">= 3.0.0"
end
