class FigureSource < ActiveRecord::Base
  belongs_to :figure
  belongs_to :source

  has_many :references, :dependent => :destroy

  serialize :info, Hash

  delegate :kind, :to => :source

  attr_writer :new_source, :which_source, :kind
  before_create :process_new_source

  def data
    source.info.merge(info)
  end

  def info
    value = super
    self.info = value = {} if value.nil?
    return value
  end

  def method_missing(sym, *args, &block)
    if sym.to_s =~ /^info_(.*\w)([=?])?$/
      name = $1
      action = $2

      case action
      when "=" then info[name.to_sym] = args.first
      when "?" then return info[name.to_sym].present?
      else return info[name.to_sym]
      end
    else
      super
    end
  end

  def respond_to?(sym, *args)
    sym.to_s =~ /^info_(.*\w)[=?]?$/ || super
  end

  private

  def process_new_source
    if @new_source && @which_source == "new"
      klass = Source.class_for(@kind)
      self.source = klass.create(@new_source)
    end
  end
end
