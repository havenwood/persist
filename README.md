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

Example in Pry (or IRB):

```ruby
require 'persist'
  #=> true

Persist.pull
  #=> {}
  
Persist.store[:siblings] = ["Katie", "Molly", "Shannnon"]
  #=> ["Katie", "Molly", "Shannnon"]

Persist.push # This saves your Stash to the persistent store.
  #=> <File:.persistent_store (closed)>
```

You can now quit IRB and your store will persist!

```ruby
require 'persist'
  #=> true

Persist.pull
  #=> {:siblings=>["Katie", "Molly", "Shannnon"]}
  
Persist.pull[:siblings]
  #=> ["Katie", "Molly", "Shannnon"]
```

## Contributing

1. Fork it
2. Commit your changes (`git commit -am 'Added some feature'`)
3. Create new Pull Request
