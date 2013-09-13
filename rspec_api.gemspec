lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

Gem::Specification.new do |s|
  s.name        = "rspec_api"
  s.version     = "0.0.1"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["claudiob"]
  s.email       = ["claudiob@gmail.com"]
  s.summary     = "Blah"
  s.description = "Blah"
  s.homepage    = "http://github.com/claudiob/rspec_api"
  s.files        = Dir.glob("lib/**/*")
  s.require_path = 'lib'

  s.required_rubygems_version = ">= 1.3.6"

  s.add_dependency 'rspec_api_documentation'
end
