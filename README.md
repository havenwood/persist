# Persist

The Persist gem is a wrapper around Ruby's PStore that allows you to persist Ruby objects to a transactional file store.

## Installation

```bash
gem install persist
```

## Usage

Example in Pry/irb:

```ruby
require 'persist'

Persist[:pie] = ['Key Lime', 'Strawberry Rhubarb', 'Blackberry Cobbler']
  # => ["Key Lime", "Strawberry Rhubarb", "Blackberry Cobbler"]
```

You can now reload Pry/irb an your objects persist:

```ruby
require 'persist'
  
Persist[:pie]
  #=> ["Key Lime", "Strawberry Rhubarb", "Blackberry Cobbler"]
```

## Transactions

Transactions succeed or fail together to ensure that data is not left in a transitory state:

```ruby
Persist.transaction do |db|
  db[:ice_cream] = ['chocolate', 'vanilla']
  db.delete :pie
end
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

Delete a table:

```ruby
Persist.delete :pie
  #=> nil
```

Check location of your persistent file store:

```ruby
Persist.path
  #=> ".db.pstore"
```

[Additional documentation](https://github.com/Havenwood/persist/blob/master/lib/persist/persist.rb) in the code.

## Supported Platforms

Persist.db takes advantage of PStore's ultra_safe attribute, which requires:

1. Compatibility with Ruby 1.9+. (Tested on 2.0.0, 1.9.3, jruby and rbx.)
2. A POSIX platform (such as OS X, GNU/Linux or a BSD).

## Contributing

1. Fork it
2. Commit changes (`git commit -am 'did something'`)
3. Submit a Pull Request
4. :cake:
