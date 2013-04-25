# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "airbrake-api/version"

Gem::Specification.new do |s|
  s.name      = 'airbrake-api'
  s.version   = AirbrakeAPI::VERSION
  s.platform  = Gem::Platform::RUBY

  s.summary = "A ruby wrapper for the Airbrake API"
  s.description = "A ruby wrapper for the Airbrake API"

  s.authors   = ['Steve Agalloco']
  s.email     = ['steve.agalloco@gmail.com']
  s.homepage  = 'https://github.com/spagalloco/airbrake-api'

  s.add_dependency 'hashie'
  s.add_dependency 'parallel'
  s.add_dependency 'faraday_middleware'
  s.add_dependency 'multi_xml'

  s.add_development_dependency 'bundler', '~> 1.0'

  s.files = %w(.rspec README.md Rakefile airbrake-api.gemspec)
  s.files += Dir.glob("lib/**/*.rb")
  s.files += Dir.glob("spec/**/*")
  s.test_files = Dir.glob("spec/**/*")
  s.require_paths = ["lib"]
end
