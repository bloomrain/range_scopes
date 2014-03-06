# coding: utf-8
$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "range_scopes/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "range_scopes"
  s.version     = RangeScopes::VERSION
  s.authors     = ["Povilas Jurčys"]
  s.email       = ["povilas@d9.lt"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of RangeScopes."
  s.description = "TODO: Description of RangeScopes."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", ">= 3.0.0"
  # s.add_dependency "jquery-rails"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "mysql2"
  s.add_development_dependency 'combustion', '~> 0.3.1'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency "factory_girl_rails"  
  s.add_development_dependency 'database_cleaner'
end
