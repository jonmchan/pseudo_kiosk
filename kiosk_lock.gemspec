$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "kiosk_lock/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "kiosk_lock"
  spec.version     = KioskLock::VERSION
  spec.authors     = ["Jonathan Chan"]
  spec.email       = ["jc@jmccc.com"]
  spec.homepage    = "https://github.com/jonmchan/kiosk_lock"
  spec.summary     = "KioskLock locks application access to a whitelist during a user session"
  spec.description = "KioskLock locks the application to an endpoint or endpoints for allowing unprivileged users to utilize a kiosk during a workflow"
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", "~> 5.2.3"

  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency 'rspec-rails'
end
