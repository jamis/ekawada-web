class Source < ActiveRecord::Base
  has_many :figure_sources
  has_many :figures, :through => :figure_sources

  serialize :info, Hash

  before_save :rebuild_sorting

  def self.info_attr(*names)
    names.each do |name|
      class_eval(<<-CODE, __FILE__, __LINE__+1)
        def #{name}; info[:#{name}]; end
        def #{name}?; info.key?(:#{name}); end
        def #{name}=(value); info[:#{name}] = value; end
      CODE
    end
  end

  def rebuild_sorting
    if changed?
      fields = field_order.map { |f| info[f] }.reject { |f| f.blank? }
      self.sorting = fields.join(" ").first(50)
    end
  end

  private # --------------------------------------------------------------

  def field_order
    raise NotImplementedError, "#field_order must be implemented in subclasses"
  end
end
