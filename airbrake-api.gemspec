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

  s.add_dependency 'hashie'
  s.add_dependency 'parallel', '~> 0.5.0'
  s.add_dependency 'faraday_middleware', '~> 0.8'
  s.add_dependency 'multi_xml'
  s.add_dependency 'mash'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'yard'
  s.add_development_dependency 'maruku'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'fakeweb'
  s.add_development_dependency 'nokogiri'
  s.add_development_dependency 'airbrake'
  s.add_development_dependency 'i18n'

  # ensure the gem is built out of versioned files
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
