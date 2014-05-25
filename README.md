# Persist
[![Build Status](https://travis-ci.org/havenwood/persist.png?branch=master)](https://travis-ci.org/havenwood/persist)

The Persist gem makes it really, really simple to persist Ruby objects to disk. Persist uses Ruby's PStore class to serialize Ruby objects with Marshal and transactionally save them for retrieval later.

## Usage
Example in irb or [Pry](http://pryrepl.org):
```ruby
require 'persist'

store = Persist.new
store[:pie] = ['Key Lime', 'Strawberry Rhubarb', 'Blackberry Cobbler']
  # => ["Key Lime", "Strawberry Rhubarb", "Blackberry Cobbler"]
```

You can now exit irb or [Pry](http://pryrepl.org) and your Ruby objects are still there:
```ruby
require 'persist'

store = Persist.new
store[:pie]
  #=> ["Key Lime", "Strawberry Rhubarb", "Blackberry Cobbler"]
```

## Transactions
Transactions succeed or fail together to ensure that data is not left in a transitory state:
```ruby
store.transaction do |db|
  db[:ice_cream] = ['chocolate', 'vanilla']
  db.delete :pie
end
```

## Helper Methods
Look up table keys:
```ruby
store.keys
  #=> [:pie, :ice_cream]

store.key? :pie
  #=> true

store.key? :cake
  #=> false
```

Delete tables:
```ruby
store.delete :pie
  #=> nil
```

## File Store Path
Set the path to the persistant store file upon initialization:
```ruby
store = Persist.new "../.db.pstore"
store.path
  #=> "../.db.pstore"
```

The default path is ".db.pstore" if one is not otherwise specified:
```ruby
store = Persist.new
store.path
  #=> ".db.pstore"
```

## Installation
Install the gem from the command line:
```bash
gem install persist
```

Or add the gem to your app's Gemfile and `bundle install`:
```ruby
gem 'persist'
```

## Supported Platforms

Persist takes advantage of PStore's [ultra_safe attribute](http://ruby-doc.org/stdlib-2.0/libdoc/pstore/rdoc/PStore.html#ultra_safe-attribute-method), which requires:

1. Ruby 1.9 or higher.
2. A POSIX compliant platform (such as OS X, GNU/Linux or a BSD).

## Contributing

1. Fork it
2. Commit changes (`git commit -am 'did something'`)
3. Submit a Pull Request
4. :cake:
