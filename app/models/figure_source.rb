class FigureSource < ActiveRecord::Base
  belongs_to :figure
  belongs_to :source

  serialize :info, Hash

  delegate :kind, :to => :source

  def data
    source.info.merge(info)
  end

  def method_missing(sym, *args, &block)
    if sym.to_s =~ /^info_(.*\w)[=?]?$/
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
end
