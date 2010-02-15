class Reference < ActiveRecord::Base
  belongs_to :construction
  belongs_to :source
end
