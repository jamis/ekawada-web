require 'notation/general'
require 'notation/mizz'

module Notation
  def self.for(name)
    case name.to_s
    when "mizz" then Notation::Mizz
    else Notation::General
    end
  end
end
