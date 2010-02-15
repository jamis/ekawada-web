class Figure < ActiveRecord::Base
  has_many :constructions, :dependent => :destroy

  scope :openings, where(:opening => true)
  scope :endings, where(:ending => true)
  scope :maneuvers, where(:maneuver => true)

  attr_writer :construction
  attr_accessor :submitter_id
  after_create :build_construction

  def build_construction_from(notation, definition, options={})
    parser = Notation.for(notation)
    parser.parse(self, definition, :construction => options.merge(:notation => notation))
  end

  def create_construction_from(notation, definition, options={})
    build_construction_from(notation, definition, options).tap do |c|
      c.save!
    end
  end

  private

    def build_construction
      return unless @construction
      notation = @construction[:notation]
      instructions = @construction[:instructions]
      @construction = nil

      create_construction_from(notation, instructions, :submitter_id => submitter_id)
    end
end
