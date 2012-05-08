require "persist/version"

class Persist
  STORE = '.persistent_store'
  
  attr_accessor :stash
  
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