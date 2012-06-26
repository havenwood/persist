module Persist
  MAJOR, MINOR, TINY = 0, 0, 9
  
  def self.version
    [MAJOR, MINOR, TINY].join '.'
  end
end