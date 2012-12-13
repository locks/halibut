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
  gem.add_dependency "nokogiri"
  gem.add_dependency "addressable"

  # this version of minitest adds parallelization
  gem.add_development_dependency "minitest", ">= 4.2"

  gem.add_development_dependency "pry", ">= 0.9.10"
  gem.add_development_dependency "pry-doc"
  gem.add_development_dependency "pry-stack_explorer"
  gem.add_development_dependency "pry-coolline", "0.1.5"
  gem.add_development_dependency "pry-rescue", "0.13"
  gem.add_development_dependency "hash-differ"

  gem.add_development_dependency "guard"
  gem.add_development_dependency "guard-bundler"
  gem.add_development_dependency "guard-minitest"

  gem.add_development_dependency "rb-fsevent"
  gem.add_development_dependency "terminal-notifier-guard"
end
