# Persist

Persist is a simple gem that allows you to painlessly save Ruby objects in a NoSQL persistent store.

## Installation

Add this line to your application's Gemfile:

    gem 'persist'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install persist

## Usage

Example in IRB:

```ruby
require 'persist'

db = Persist.new
  #=> #<Persist:0x007fa5ca29f258 @stash={}>

db.stash[:siblings] = ["Katie", "Molly", "Shannnon"]
  #=> {:siblings=>["Katie", "Molly", "Shannnon"]}

db.push # This saves your Stash to the persistent store.
  #=> <File:.persistent_store (closed)>
  
  # You can now quit IRB and your stash will persist.
  
db = Persist.new # In a new Irb session.
  #=> #<Persist:0x007fb8c519e7d8 @stash={:siblings=>["Katie", "Molly", "Shannnon"]}
  
db.stash[:siblings]
  #=> ["Katie", "Molly", "Shannnon"]
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
