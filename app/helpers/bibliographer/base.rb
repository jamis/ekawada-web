module Bibliographer
  class Base
    def self.info_attr(*list)
      list.each do |name|
        class_eval(<<-CODE, __FILE__, __LINE__+1)
          def #{name}; attributes[:#{name}].to_s; end
          def #{name}?; attributes[:#{name}].present?; end
          def #{name}=(value); attributes[:#{name}] = value; end
        CODE
      end
    end

    def self.format(attributes)
      new(attributes).format
    end

    attr_reader :attributes

    def initialize(attributes)
      @attributes = attributes
    end

    def publication_title(title)
      "<cite>#{title}</cite>"
    end

    def hyperlink(url)
      "<a href=\"#{url}\" target=\"_blank\">#{url}</a>"
    end
  end
end
