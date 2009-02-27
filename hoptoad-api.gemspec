# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{hoptoad-api}
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Steve Agalloco"]
  s.date = %q{2009-02-26}
  s.description = %q{An unofficial gem for interacting with the Hoptoad API}
  s.email = %q{steve.agalloco@gmail.com}
  s.files = ["README.textile", "VERSION.yml", "lib/hoptoad-api.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/spagalloco/hoptoad-api}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{An unofficial gem for interacting with the Hoptoad API}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
