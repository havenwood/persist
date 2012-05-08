# -*- encoding: utf-8 -*-
require File.expand_path('../lib/persist/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Shannon"]
  gem.email         = ["shannonskipper@gmail.com"]
  gem.description   = %q{Simple NoSQL Persistent Object Store for Ruby}
  gem.summary       = %q{This gem allows you to save Ruby Objects to a persistent store and recover them later.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "persist"
  gem.require_paths = ["lib"]
  gem.version       = Persist::VERSION
end