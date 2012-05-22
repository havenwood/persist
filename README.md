# Persist.db

Persist.db is a simple gem that allows you to painlessly save Ruby Objects in a NoSQL persistent file store.

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

Persist.db
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
```

You can now quit IRB and your store will persist!

```ruby
require 'persist'
  #=> true

Persist[:pie]
  #=> ["Key Lime", "Strawberry Rhubarb", "Blackberry Cobbler"]
```

TODO: Document Persist.db's other public methods such as #transaction, #delete, #key? and #keys. The best documentation in the meanwhile is in the code itself: https://github.com/Havenwood/persist/blob/master/lib/persist.rb

## Contributing

1. Fork it
2. Commit your changes (`git commit -am 'Did something'`)
3. Create new Pull Request
