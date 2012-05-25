# Persist.db

Persist.db implements a DSL around Ruby Standard Library's PStore to facilitate simple file-persistant storage of Ruby objects in a transactional NoSQL database.

## Installation

Add this line to your application's Gemfile:

    gem 'persist'

And then execute:

    $ bundle

Or install it yourself:

    $ gem install persist

## Usage

Example in Pry (or IRB if you must):

```ruby
require 'persist'
  #=> true

Persist.pull
 # => #<PStore:0x007f8c199c9698
   @abort=false,
   @filename=".db.pstore",
   @lock=#<Mutex:0x007f8c199c9580>,
   @rdonly=true,
   @table={},
   @thread_safe=true,
   @ultra_safe=true>
  
Persist[:pie] = ['Key Lime', 'Strawberry Rhubarb', 'Blackberry Cobbler']
  # => ["Key Lime", "Strawberry Rhubarb", "Blackberry Cobbler"]

Persist[:ice_cream] = ['chocolate', 'vanilla']
  # => ["chocolate", "vanilla"]
```

You can now exit Pry/IRB and your store will persist!

```ruby
require 'persist'
  #=> true
  
Persist.pull
  #=> #<PStore:0x007f8c199c9698 ... >
  
Persist[:pie]
  #=> ["Key Lime", "Strawberry Rhubarb", "Blackberry Cobbler"]
```

## Helper Methods

Each of Persist.db's tables is stored as a key:

```ruby
Persist.keys
  #=> [:pie, :ice_cream]

Persist.key? :pie
  #=> true

Persist.key? :cake
  #=> false
```

Tables can be clobbered:

```ruby
Persist.delete :pie
  #=> nil
```

To check the location of your persistent store file:

```ruby
Persist.path
  #=> ".db.pstore"
```

Transactions succeed or fail together to ensure that data is not left in a transitory state:

```ruby
Persist.transaction do
  Persist.db[:cake] = 'pie is better!'
  Persist.db.delete :pie
end
```

[Additional documentation](https://github.com/Havenwood/persist/blob/master/lib/persist/persist.rb) in the code.

## Supported Platforms

Persist.db makes use of PStore's ultra_safe attribute, which requires:

1. Ruby 1.9.2 or greater or Rubinius in 1.9 mode (`rvm install rbx --1.9` or rbx with -X19 command line flag).
2. A POSIX platform such as OS X, GNU/Linux or FreeBSD.

## Contributing

1. Fork it.
2. Commit changes (`git commit -am 'did something'`).
3. Pull Request.