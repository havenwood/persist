# Public: Implements a DSL around Ruby Standard Library's PStore to facilitate
# simple file-persistant storage of Ruby objects in a transactional NoSQL
# database.
module Persist
  class << self
    # Public: Returns the persistant store Object if initialized.
    attr_reader :store
    
    # Public: Initialize the PStore Object--deserializing the marshalled Hash
    # stored in the '.db.pstore' file (creating the file if it does't exist)--
    # and set thread_safe and ultra_safe to true.
    #
    # Examples
    #
    #   Persist.db
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
    def db
      @store = PStore.new '.db.pstore', true
      @store.ultra_safe = true
      @store.transaction(true) {}
      @store
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
      @store.transaction true do
        @store.roots
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
      @store.transaction true do
        @store.root? table
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
      @store.transaction true do
        @store[table]
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
      @store.transaction do
        @store[table] = value
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
    #     Persist.store[:weather] = 'sunny'
    #     Persist.store[:hour] = 'midday'
    #   end
    #   # => nil
    #
    # Returns nothing.
    def transaction &block
      @store.transaction do
        yield
        @store.commit
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
      @store.transaction do
        tables.each do |table|
          @store.delete table
        end
        @store.commit
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
      @store.path
    end
  end
end