$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "preroller/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "preroller"
  s.version     = Preroller::VERSION
  s.authors     = ["Eric Richardson"]
  s.email       = ["e@ericrichardson.com"]
  s.homepage    = "http://github.com/SCPR/Preroller"
  s.summary     = "Rails engine to manage and deliver audio prerolls"
  s.description = "Rails engine to manage and deliver audio prerolls"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 3.2.2"
  s.add_dependency "streamio-ffmpeg"
  s.add_dependency "simple_form"
  s.add_dependency "less-rails-bootstrap"
  s.add_dependency "resque"

  s.add_development_dependency "rspec-rails", '~> 2.13.0'
  s.add_development_dependency "factory_girl"
end
