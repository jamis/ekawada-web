class Construction < ActiveRecord::Base
  belongs_to :figure
  belongs_to :submitter, :class_name => "User"
  has_many   :steps, :order => "position", :dependent => :destroy
  has_many   :references, :dependent => :destroy
  has_many   :sources, :through => :references
  has_many   :illustrations, :as => :parent, :order => "position", :dependent => :destroy

  composed_of :notation, :mapping => %w(notation_id id)

  before_save :parse_definition

  scope :for, lambda { |notation_id| where(:notation_id => notation_id) }

  def self.find_best_match(name, notation_id)
    c = Construction.find_by_name_and_notation_id(name, notation_id)
    return c if c

    figures = Figure.find_all_by_canonical_name(name, :include => :constructions)
    aliases = Alias.find_all_by_name(name, :include => { :figure => :constructions })
    figures += aliases.map(&:figure)

    figures.each do |figure|
      c = figure.constructions.detect { |c| c.notation_id == notation_id }
      return c if c
    end

    raise ActiveRecord::RecordNotFound, "no match for #{name.inspect} in #{notation_id.inspect}"
  end

  def figure_name
    name.present? ? name : figure.canonical_name
  end

  def flag_for_review
    self.reviewed_at = self.reviewed_by = nil
  end

  def start_at
    notation.start_at(:construction => self)
  end

  private # --------------------------------------------------------------

  def parse_definition
    if definition_changed?
      steps.clear
      flag_for_review
      notation.parse(definition) do |position, data|
        steps.build(data.merge(:position => position))
      end
    end
  end
end
