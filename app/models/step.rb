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

  def wants_paragraphs?
    instruction && instruction.include?("\n")
  end

  def display_name
    if name.present? 
      name
    elsif figure
      figure.canonical_name
    end
  end
end
