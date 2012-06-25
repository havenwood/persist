module Persist
  MAJOR, MINOR, TINY = 0, 0, 8
  
  def self.version
    [MAJOR, MINOR, TINY].join '.'
  end
end