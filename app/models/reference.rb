class Reference < ActiveRecord::Base
  belongs_to :construction
  belongs_to :figure_source
  delegate :source, :to => :figure_source
end
