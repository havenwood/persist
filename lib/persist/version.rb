module Persist
  class << self
    def version
      [major, minor, tiny].join '.'
    end
    
    private
    
    def major
      0
    end
  
    def minor
      1
    end
  
    def tiny
      0
    end
  end
end