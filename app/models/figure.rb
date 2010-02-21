class Figure < ActiveRecord::Base
  has_many :aliases, :dependent => :destroy
  has_many :constructions, :dependent => :destroy
  has_many :figure_sources, :dependent => :destroy
  has_many :sources, :through => :figure_sources
  has_many :illustrations, :as => :parent, :order => "position", :dependent => :destroy

  scope :openings, where(:opening => true)
  scope :endings, where(:ending => true)
  scope :maneuvers, where(:maneuver => true)

  attr_writer :construction
  attr_accessor :submitter_id
  after_create :create_construction

  private

    def create_construction
      return unless @construction
      constructions.create(@construction.merge(:submitter_id => submitter_id))
      @construction = nil
    end
end
