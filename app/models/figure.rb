class Figure < ActiveRecord::Base
  has_many :aliases, :dependent => :destroy
  has_many :constructions, :dependent => :destroy
  has_many :figure_sources, :dependent => :destroy
  has_many :sources, :through => :figure_sources
  has_many :illustrations, :as => :parent, :order => "position"

  scope :openings, where(:opening => true)
  scope :endings, where(:ending => true)
  scope :maneuvers, where(:maneuver => true)

  attr_writer :construction
  attr_accessor :submitter_id
  after_create :build_construction

  def build_construction_from(options)
    parser = Notation.behavior_for(options[:notation])
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
      create_construction_from(@construction.merge(:submitter_id => submitter_id))
      @construction = nil
    end
end
