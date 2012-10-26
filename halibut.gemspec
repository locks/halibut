# -*- encoding: utf-8 -*-
require File.expand_path('../lib/halibut/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Ricardo Mendes"]
  gem.email         = ["rokusu@gmail.com"]
  gem.description   = %q{Toolkit to work with HAL}
  gem.summary       = %q{A HAL parser and builder for use in Hypermedia APIs}
  gem.homepage      = "http://locks.github.com/halibut"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "halibut"
  gem.require_paths = ["lib"]
  gem.version       = Halibut::VERSION

  gem.required_ruby_version = '~> 1.9.3'

  gem.add_dependency "multi_json"
  gem.add_dependency "addressable"

  gem.add_development_dependency "minitest"
  gem.add_development_dependency "pry-full"
  gem.add_development_dependency "pry-coolline"
  gem.add_development_dependency "pry-rescue", '0.13.pre.2'
  gem.add_development_dependency "pry-stack_explorer"

  gem.add_development_dependency "guard"
  gem.add_development_dependency "guard-bundler"
  gem.add_development_dependency "guard-minitest"

  gem.add_development_dependency "rb-fsevent"
  gem.add_development_dependency "terminal-notifier-guard"

end
