# -*- encoding: utf-8 -*-
require File.expand_path('../lib/persist/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Shannon Skipper']
  gem.email         = ['shannonskipper@gmail.com']
  gem.description   = %q{The Persist gem makes it really, really simple to persist Ruby objects to disk.}
  gem.summary       = %q{Persist Ruby objects to a transactional file store using Ruby's Pstore.}
  gem.homepage      = 'https://github.com/havenwood/persist'
  gem.license       = 'MIT'
  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^test/})
  gem.name          = 'persist'
  gem.require_paths = ['lib']
  gem.version       = Persist::VERSION
  gem.add_development_dependency 'minitest'
  gem.add_development_dependency 'rake'
end
