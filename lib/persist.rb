require 'pstore'
require 'persist/version'

# Public: Implements a DSL around Ruby Standard Library's PStore to facilitate
# simple file-persistant storage of Ruby objects in a transactional NoSQL
# database.
module Persist
  class << self
    # Returns the persistant store Object if one has been initialized.
    attr_reader :store
    
    # Public: Initialize the PStore Object, deserializing the marshalled Hash
    # stored in the '.db.pstore' file (creating the file if it does't exist).
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
      # Initialize a persistent store in the file '.db.pstore' and set
      # thread_safe to true.
      @store = PStore.new('.db.pstore', true)
      
      # Set ultru_safe to true for extra safety checks regarding full disk, etc.
      @store.ultra_safe = true
      
      # Open a read-only transaction to fetch latest store.
      @store.transaction(true) {}
      
      # Return the entire fetched store Object.
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
      # Open a read-only transaction.
      @store.transaction(true) do
        #Return a list of all tables in the persistent store.
        @store.roots
      end
    end
    
    alias tables keys
    
    # Public: Fetch a particular table from the persistent store.
    #
    # table - A Symbol.
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
      # Open a read-only transaction.
      @store.transaction(true) do
        # Return a particular table from the persistent store.
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
      # Open a writable transaction.
      @store.transaction do
        # Process the single transaction.
        @store[table] = value
      end # Commit transaction.
    end
    
    # Public: Process multiple transactions to set table values and commit if
    # all are transactions are successful.
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
    
    # Public: Delete an entire root table from the persistent store.
    #
    # Examples
    #
    #   Persist.delete :author
    #   # => nil
    #
    # Returns nothing.
    def delete table
      # Open a writable transaction.
      @store.transaction do
        # Delete a particular table from the persistent store.
        @store.delete table
      end
    end
  end
end