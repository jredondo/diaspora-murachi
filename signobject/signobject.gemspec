$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "signobject/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "signobject"
  s.version     = Signobject::VERSION
  s.authors     = [""]
  s.email       = [""]
  s.homepage    = "https://github.com/signobject"
  s.summary     = "SIGNOBJECT: Summary of Signobject."
  s.description = "SIGNOBJECT: Description of Signobject."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.3"

  s.add_development_dependency "sqlite3"
end
