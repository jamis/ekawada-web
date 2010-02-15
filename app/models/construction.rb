class Construction < ActiveRecord::Base
  belongs_to :figure
  belongs_to :submitter, :class_name => "User"
  has_many   :steps, :order => "position", :dependent => :destroy
  has_many   :references, :dependent => :destroy
  has_many   :sources, :through => :references

  scope :for, lambda { |notation| where(:notation => notation) }

  def self.find_best_match(name, notation)
    c = Construction.find_by_name_and_notation(name, notation)
    return c if c

    figures = Figure.find_all_by_common_name(name, :include => :constructions)
    figures.each do |figure|
      c = figure.constructions.detect { |c| c.notation == notation }
      return c if c
    end

    raise ActiveRecord::RecordNotFound, "no match for #{name.inspect} in #{notation.inspect}"
  end

  def common_name
    name.present? ? name : figure.common_name
  end

  def update_with_definition(options={})
    parser = Notation.for(notation)
    transaction do
      parser.parse(figure, options[:definition], options.merge(:construction => self))
      save!
    end
  end
end
