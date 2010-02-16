require 'notation/general'
require 'notation/mizz'

module Notation
  def self.behavior_for(name)
    case name.to_s
    when "mizz" then Notation::Mizz
    else Notation::General
    end
  end

  def self.for(id)
    MAP[id]
  end

  class Type
    include Comparable

    attr_reader :id

    def initialize(id, attributes)
      @id = id
      @attributes = attributes
    end

    def name(type=:full)
      case type
      when :full then @attributes["full"]
      when :short then @attributes["short"] || @attributes["full"]
      else raise ArgumentError, "unknown name type: #{type.inspect}"
      end
    end

    def to_i
      @attributes["sort"].to_i
    end

    def <=>(type)
      self.to_i <=> type.to_i
    end

    def to_s
      name
    end
  end

  TYPES = YAML.load_file(File.join(File.dirname(__FILE__), "..", "config", "notations.yml")).inject([]) { |a,(id,data)| a << Type.new(id, data) }.sort
  MAP   = TYPES.inject({}) { |h,type| h.merge(type.id => type) }
end
