class Step < ActiveRecord::Base
  belongs_to :construction

  # the intermediate figure formed after executing this step
  belongs_to :figure

  # the duplicate construction that this step references
  belongs_to :duplicate, :class_name => "Construction"
end
