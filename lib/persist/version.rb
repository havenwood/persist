module Persist
  class << self
    def major
      0
    end
  
    def minor
      1
    end
  
    def tiny
      0
    end
  
    def version
      [major, minor, tiny].join '.'
    end
  end
end