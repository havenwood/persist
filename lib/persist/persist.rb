require 'pstore'

# Public: Implements a DSL around Ruby Standard Library's PStore to facilitate
# simple file-persistant storage of Ruby objects in a transactional NoSQL
# database. All methods are module methods and should be called on the Persist
# module.
module Persist
  class << self
    # Public: Returns the persistant store Object if initialized.
    attr_reader :db
    
    # Public: Initialize the PStore Object--deserializing the marshalled Hash
    # stored in the '.db.pstore' file (creating the file if it does't exist)--
    # and set thread_safe and ultra_safe to true.
    #
    # Examples
    #
    #   Persist.pull
    #   # => #<PStore:0x007f8c199c9698
    #     @abort=false,
    #     @filename=".db.pstore",
    #     @lock=#<Mutex:0x007f8c199c9580>,
    #     @rdonly=true,
    #     @table={},
    #     @thread_safe=true,
    #     @ultra_safe=true>
    #
    # Returns the entire persistent store Object.
    def pull
      @db = PStore.new '.db.pstore', true
      @db.ultra_safe = true
      @db.transaction(true) {}
      @db
    end
    
    # Public: Fetch a list of persistent store root tables.
    #
    # Examples
    #
    #   Persist.keys
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
    #   Persist.key? :author
    #   # => true
    #
    #   Persist.key? :this_does_not_exist
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
    #   Persist[:author]
    #   # => {:first_name => "Shannon", :last_name => "Skipper"}
    #
    #   Persist[:author][:first_name]
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
    #   Persist.fetch :author
    #   # => {:first_name => "Shannon", :last_name => "Skipper"}
    #
    #   Persist.fetch :snowman
    #   # => nil
    #
    #   Persist.fetch :snowman, 'default value instead of nil'
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
    #   Persist[:sky] = 'blue'
    #   # => "blue"
    #
    # Returns the value of the table.
    def []= table, value
      @db.transaction do
        @db[table] = value
      end
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
    #   Persist.transaction do
    #     Persist.db[:weather] = 'sunny'
    #     Persist.db.delete[:author]
    #   end
    #   # => nil
    #
    # Returns nothing.
    def transaction &block
      @db.transaction do
        yield
        @db.commit
      end
    end
    
    # Public: Delete one or more entire root tables from the persistent store.
    #
    # tables - One or more Symbols corresponding to root table keys in the
    #          persistent store.
    #
    # Examples
    #
    #   Persist.delete :author
    #   # => nil
    #
    #   Persist.delete :author, :clients, :rentals
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
    
    # Public: Determine location of the persistent store file.
    #
    # Examples
    #
    #   Persist.path
    #   # => ".db.pstore"
    #
    # Returns the path to the data file as a String.
    def path
      @db.path
    end
  end
end