require 'rubygems'
require 'rake'

$LOAD_PATH.unshift 'lib'

begin
  require 'jeweler'
  require 'hoptoad-api/version'
  
  Jeweler::Tasks.new do |gem|
    gem.name = "hoptoad-api"
    gem.summary = %Q{An unofficial gem for interacting with the Hoptoad API}
    gem.email = "steve.agalloco@gmail.com"
    gem.homepage = "http://github.com/spagalloco/hoptoad-api"
    gem.description = "An unofficial gem for interacting with the Hoptoad API"
    gem.authors = ["Steve Agalloco"]
    gem.version = Hoptoad::VERSION
    
    gem.add_dependency(%q<httparty>, [">= 0.5.2"])
    gem.add_dependency(%q<hashie>, [">= 0.2.0"])
    
    gem.add_development_dependency "shoulda", ">= 0"
    gem.add_development_dependency "fakeweb", ">= 0"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = Hoptoad::VERSION

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "hoptoad-api #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
