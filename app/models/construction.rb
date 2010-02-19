class Construction < ActiveRecord::Base
  belongs_to :figure
  belongs_to :submitter, :class_name => "User"
  has_many   :steps, :order => "position", :dependent => :destroy
  has_many   :references, :dependent => :destroy
  has_many   :sources, :through => :references
  has_many   :illustrations, :as => :parent, :order => "position"

  scope :for, lambda { |notation| where(:notation => notation) }

  def self.find_best_match(name, notation)
    c = Construction.find_by_name_and_notation(name, notation)
    return c if c

    figures = Figure.find_all_by_canonical_name(name, :include => :constructions)
    aliases = Alias.find_all_by_name(name, :include => { :figure => :constructions })
    figures += aliases.map(&:figure)

    figures.each do |figure|
      c = figure.constructions.detect { |c| c.notation == notation }
      return c if c
    end

    raise ActiveRecord::RecordNotFound, "no match for #{name.inspect} in #{notation.inspect}"
  end

  def figure_name
    name.present? ? name : figure.canonical_name
  end

  def meta
    @meta ||= Notation.behavior_for(notation).new(figure, :construction => self)
  end

  def notation_info
    @notation_info ||= Notation.for(notation)
  end

  def update_with_definition(options={})
    transaction do
      meta.parse(options[:definition])
      save!
    end
  end
end
