class Source < ActiveRecord::Base
  has_many :figure_sources
  has_many :figures, :through => :figure_sources

  serialize :info, Hash

  def self.info_attr(*names)
    names.each do |name|
      class_eval(<<-CODE, __FILE__, __LINE__+1)
        def #{name}; info[:#{name}]; end
        def #{name}?; info.key?(:#{name}); end
        def #{name}=(value); info[:#{name}] = value; end
      CODE
    end
  end
end
