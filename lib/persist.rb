require 'pstore'

# Public: Implements a DSL around Ruby Standard Library's PStore to facilitate
# simple file-persistant storage of Ruby objects in a transactional NoSQL
# database.
class Persist
  # Public: Returns the persistant store Object if initialized.
  attr_reader :db

  # Public: Returns the path to the persistent store file.
  attr_reader :path

  # Initializes the PStore Object and sets thread_safe and ultra_safe to true.
  # Creates the file store at the specified path if it does not exist. 
  #
  # path - An optional String representing the relative path of the file.
  #
  # Examples
  #
  #   store = Persist.new
  #   # => #<Persist:0x007f97b1b1b930
  #     @db=
  #       #<PStore:0x007f97b1b1b8e0
  #        @abort=false,
  #        @filename=".db.pstore",
  #        @lock=#<Mutex:0x007f97b1b1b7c8>,
  #        @rdonly=true,
  #        @table=
  #         {:trees=>["oak", "pine", "cedar"],
  #          :one=>"first",
  #          :two=>"second",
  #          :author=>{:first_name=>"Shannon", :last_name=>"Skipper"},
  #          :aim=>true,
  #          :pie=>["Key Lime", "Strawberry Rhubarb", "Blackberry Cobbler"]},
  #        @thread_safe=true,
  #        @ultra_safe=true>,
  #      @path=".db.pstore">
  #
  # Returns the entire persistent store Object.
  def initialize path = '.db.pstore'
    @path = path
    @db = PStore.new path, true
    @db.ultra_safe = true
    @db.transaction(true) {}
    @db
  end

  # Public: Process multiple transactions to set table values and commit if
  # all transactions are successful.
  #
  # block - A required block that processes multiple transactions that 
  #         succeed or fail together to ensure that data is not left in a 
  #         transitory state.
  #
  # Examples
  #
  #   store.transaction do |db|
  #     db[:weather] = 'sunny'
  #     db.delete[:author]
  #   end
  #   # => nil
  #
  # Returns nothing.
  def transaction
    @db.transaction do
      yield @db
      @db.commit
    end
  end

  # Public: Fetch a list of persistent store root tables.
  #
  # Examples
  #
  #   store.keys
  #   # => [:author]
  #
  # Returns an Array containing the persistent store root tables.
  def keys
    @db.transaction true do
      @db.roots
    end
  end

  # Public: Determine whether a particular persistent store root table
  # exists.
  #
  # table - A Symbol.
  #
  # Examples
  #
  #   store.key? :author
  #   # => true
  #
  #   store.key? :this_does_not_exist
  #   # => false
  #
  # Returns true or false.
  def key? table
    @db.transaction true do
      @db.root? table
    end
  end

  # Public: Fetch a particular table from the persistent store.
  #
  # table - A Symbol corresponding to a root table key in the persistent 
  #         store.
  #
  # Examples
  #
  #   store[:author]
  #   # => {:first_name => "Shannon", :last_name => "Skipper"}
  #
  #   store[:author][:first_name]
  #   # => "Shannon"
  #
  # Returns the value stored in the fetched table.
  def [] table
    @db.transaction true do
      @db[table]
    end
  end

  # Public: Fetch a particular table from the persistent store.
  #
  # table   - A Symbol corresponding to a root table key in the persistent 
  #           store.
  #
  # default - An optional value that is returned if the table is not found.
  #
  # Examples
  #
  #   store.fetch :author
  #   # => {:first_name => "Shannon", :last_name => "Skipper"}
  #
  #   store.fetch :snowman
  #   # => nil
  #
  #   store.fetch :snowman, 'default value instead of nil'
  #   # => "default value instead of nil"
  #
  # Returns the value stored in the fetched table.
  def fetch table, default = nil
    @db.transaction true do
      @db.fetch table, default
    end
  end

  # Public: Use a single transaction to set a table value.
  #
  # table - A Symbol.
  #
  # value - Any Ruby Object that is marshallable.
  #
  # Examples
  #
  #   store[:sky] = 'blue'
  #   # => "blue"
  #
  # Returns the value of the table.
  def []= table, value
    @db.transaction do
      @db[table] = value
    end
  end

  # Public: Delete one or more entire root tables from the persistent store.
  #
  # tables - One or more Symbols corresponding to root table keys in the
  #          persistent store.
  #
  # Examples
  #
  #   store.delete :author
  #   # => nil
  #
  #   store.delete :author, :clients, :rentals
  #   # => nil
  #
  # Returns nothing.
  def delete *tables
    @db.transaction do
      tables.each do |table|
        @db.delete table
      end
      @db.commit
    end
  end
end
