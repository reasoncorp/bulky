$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "bulky/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "bulky"
  s.version     = Bulky::VERSION
  s.authors     = ["Adam Hunter", "Ben Vandgrift"]
  s.email       = ["adamhunter@tma1.com", "ben@tma1.com"]
  s.homepage    = "https://github.com/tma1/bulky"
  s.summary     = "Bulk update your ActiveRecord models."
  s.description = "Bulky allows you bulk update your ActiveRecord models.  It will enqueue the bulk update and run it through the model's lifecycle to ensure validation are performed. Bulky also provides logging of bulk update success or failure."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]

  s.required_ruby_version = ">= 2.2.2"

  s.add_dependency "rails",   "~> 4.2.0"
  s.add_dependency "sidekiq", "~> 3.5.0"
  s.add_dependency "haml",    ">= 4.0"

  s.add_development_dependency "pry"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails",      "~> 3.3.3"
  s.add_development_dependency "database_cleaner", ">= 1.4.1"
end
