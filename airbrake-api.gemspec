# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
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

  s.add_dependency 'httparty', '~> 0.8.0'
  s.add_dependency 'hashie', '~> 1.1.0'
  s.add_dependency 'parallel', '~> 0.5.0'

  s.add_development_dependency 'rake', '~> 0.9.2'
  s.add_development_dependency 'rspec', '~> 2.6.0'
  s.add_development_dependency 'yard', '~> 0.7.2'
  s.add_development_dependency 'maruku', '~> 0.6'
  s.add_development_dependency 'simplecov', '~> 0.4.2'
  s.add_development_dependency 'fakeweb', '~> 1.3.0'
  s.add_development_dependency 'nokogiri', '~> 1.4'
  s.add_development_dependency 'airbrake', '~> 3.0'
  s.add_development_dependency 'i18n', '~> 0.6.0'

  # ensure the gem is built out of versioned files
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
