class FigureSource < ActiveRecord::Base
  belongs_to :figure
  belongs_to :source

  serialize :info, Hash

  delegate :kind, :to => :source

  def data
    source.info.merge(info)
  end
end
