class FigureSource < ActiveRecord::Base
  belongs_to :figure
  belongs_to :source
end
