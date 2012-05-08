require "persist/version"

module Persist
  class << self
    STORE = '.persistent_store'
  
    attr_accessor :store
  
    def initialize
      unless File.exists? STORE
        self.reset!
      end
      self.pull
    end
  
    def pull
      @stash = Marshal.load File.read(STORE)
    end
  
    def push
      File.open STORE, 'w' do |store|
        store << Marshal.dump(@stash)
      end
    end
  
    def reset!
      File.open STORE, 'w' do |store|
        store << Marshal.dump({})
      end
    end
  end
end