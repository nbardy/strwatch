# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'strwatch/version'
require 'strwatch'

Gem::Specification.new do |gem|
  gem.name          = "strwatch"
  gem.version       = Strwatch::VERSION
  gem.authors       = ["Nicholas Bardy"]
  gem.email         = ["nicholasbardy@yahoo.com"]
  gem.description   = %q{Live updates in views with data-binding to models}
  gem.summary       = %q{Live views}
  gem.homepage      = "http://github.com/nbardy/strwatch"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  
  gem.add_development_dependency "bundler"
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "sqlite3"
  gem.add_development_dependency "rake"

  # Rails stuff
  gem.add_dependency "activerecord"
  gem.add_dependency "actionpack"
  gem.add_dependency "activesupport"
  
  gem.add_dependency "json"
end
