class Figure < ActiveRecord::Base
  has_many :constructions, :dependent => :destroy

  scope :openings, where(:opening => true)
  scope :endings, where(:ending => true)
  scope :maneuvers, where(:maneuver => true)

  attr_writer :construction
  attr_accessor :submitter_id
  after_create :build_construction

  def build_construction_from(options)
    parser = Notation.for(options[:notation])
    parser.parse(self, options[:definition], :construction => options)
  end

  def create_construction_from(options)
    build_construction_from(options).tap do |c|
      c.save!
    end
  end

  private

    def build_construction
      return unless @construction
      create_construction_from(:construction => @construction.merge(:submitter_id => submitter_id))
      @construction = nil
    end
end
