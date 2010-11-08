$:.push File.expand_path("../lib", __FILE__)
require "hoptoad-api/version"

Gem::Specification.new do |gem|
  gem.name    = 'hoptoad-api'
  gem.version = Hoptoad::VERSION
  gem.date    = Date.today.to_s

  gem.summary = "Hoptoad API"
  gem.description = "An unofficial gem for interacting with the Hoptoad API"

  gem.authors  = ['Steve Agalloco']
  gem.email    = 'steve.agalloco@gmail.com'
  gem.homepage = 'http://github.com/spagalloco/hoptoad-api'

  gem.add_dependency(%q<httparty>, [">= 0.5.2"])
  gem.add_dependency(%q<hashie>, [">= 0.2.0"])

  gem.add_development_dependency(%q<shoulda>, [">= 0"])
  gem.add_development_dependency(%q<fakeweb>, [">= 0"])
  gem.add_development_dependency(%q<rcov>, [">= 0"])

  # ensure the gem is built out of versioned files
  gem.files = Dir['Rakefile', '{bin,lib,man,test,spec}/**/*', 'README*', 'LICENSE*'] & `git ls-files -z`.split("\0")
end