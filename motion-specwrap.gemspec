# -*- encoding: utf-8 -*-
require File.expand_path('../lib/motion-specwrap/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Keyvan Fatehi"]
  gem.email         = ["keyvanfatehi@gmail.com"]
  gem.description   = "Exit value support wrapper for RubyMotion's 'rake spec'"
  gem.summary       = "Exit value support wrapper for RubyMotion's 'rake spec'"
  gem.homepage      = "https://github.com/mdks/motion-specwrap"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "motion-specwrap"
  gem.require_paths = ["lib"]
  gem.version       = Motion::Specwrap::VERSION
end
