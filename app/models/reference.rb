class Reference < ActiveRecord::Base
  belongs_to :construction
  belongs_to :figure_source
  belongs_to :source, :through => :figure_source
end
