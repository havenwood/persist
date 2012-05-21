# -*- encoding: utf-8 -*-
require File.expand_path('../lib/persist/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Shannon"]
  gem.email         = ["shannonskipper@gmail.com"]
  gem.description   = %q{A DSL for storing Ruby Objects transactionally in a persistent NoSQL database}
  gem.summary       = %q{Persist.db is a DSL implemented around Ruby Standard Library's PStore to facilitate simple file-persistant storage of Ruby objects in a transactional NoSQL database.}
  gem.homepage      = "https://github.com/Havenwood/persist"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^test/})
  gem.name          = "persist"
  gem.require_paths = ["lib"]
  gem.version       = Persist::VERSION
end