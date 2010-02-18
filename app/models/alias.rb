class Alias < ActiveRecord::Base
  belongs_to :figure
  serialize :locations, Array
end
