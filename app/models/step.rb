class Step < ActiveRecord::Base
  belongs_to :construction

  # the intermediate figure formed after executing this step
  belongs_to :figure

  # the duplicate construction that this step references
  belongs_to :duplicate, :class_name => "Construction"

  def range?
    duplicate_type == "range"
  end

  def make?
    duplicate_type == "make"
  end

  def silent?
    duplicate_type.blank? && instruction.blank?
  end

  def named?
    name.present? || figure
  end

  def display_name
    if name.present? 
      name
    elsif figure
      figure.common_name
    end
  end
end
