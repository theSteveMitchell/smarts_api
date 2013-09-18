# -*- encoding: utf-8 -*-
require File.expand_path('../lib/smarts_api/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Steve Mitchell"]
  gem.email         = ["theSteveMitchell@gmail.com"]
  gem.description   = "smarts_api-#{SmartsApi::Version::STRING}"
  gem.summary       = "api gem for Sparkling Logic's SMARTS business logic platform"
  gem.homepage      = "http://github.com/theSteveMitchell/smarts_api"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "smarts_api"
  gem.require_paths = ["lib"]
  gem.version       = SmartsApi::Version::STRING
end
