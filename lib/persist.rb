require "persist/version"

module Persist
  class << self
    STORE = '.persistent_store'
  
    attr_accessor :store
  
    def pull
      unless File.exists? STORE
        self.reset!
      end
      @store = Marshal.load File.read(STORE)
    end
  
    def push
      File.open STORE, 'w' do |store|
        store << Marshal.dump(@store)
      end
    end
  
    def reset!
      File.open STORE, 'w' do |store|
        store << Marshal.dump({})
      end
    end
  end
end