require 'notation/general'
require 'notation/mizz'

module Notation
  def self.for(name)
    case name.to_s
    when "mizz" then Notation::Mizz
    else Notation::General
    end
  end

  MAP = {
    "isfa"  => "ISFA Standard (Storer-D'Antoni)",
    "mizz"  => "Mizz Code",
    "sfn"   => "String Figure Notation (SFN)",
    "fsfn"  => "Formal String Figure Notation (FSFN)",
    "haddon-rivers" => "Haddon-Rivers Notation",
    "cfj"   => "CFJ Notation",
    "prose" => "Other prose",
    "other" => "Other notation",
  }
end
