module Bibliographer
  def self.format(type, attributes)
    converter = const_get(type.to_s.classify)
    converter.format(attributes)
  end
end
