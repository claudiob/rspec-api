lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rspec-api/version'

Gem::Specification.new do |spec|
  spec.name          = "rspec-api"
  spec.version       = RspecApi::VERSION
  spec.authors       = ["claudiob"]
  spec.email         = ["claudiob@gmail.com"]
  spec.description   = %q{Helpers to write specs for web APIs}
  spec.summary       = %q{Extends rspec_api_documentation with methods to
    write more compact and meaningful, auto-documented specs for web APIs.}
  spec.homepage      = 'https://github.com/claudiob/rspec-api'
  spec.license       = 'MIT'

  spec.files         = Dir['{lib}/**/*'] + ['MIT-LICENSE', 'README.md']

  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 1.9.0'

  spec.required_rubygems_version = ">= 1.3.6"

  spec.add_dependency 'rspec-api-documentation'
end