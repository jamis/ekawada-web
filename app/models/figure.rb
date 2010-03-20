class Figure < ActiveRecord::Base
  include Illustrated

  has_many :aliases, :dependent => :destroy
  has_many :constructions, :dependent => :destroy
  has_many :figure_sources, :dependent => :destroy
  has_many :sources, :through => :figure_sources

  scope :openings, where(:opening => true)
  scope :endings, where(:ending => true)
  scope :maneuvers, where(:maneuver => true)

  attr_writer :construction
  attr_accessor :submitter_id, :new_aliases

  after_create :create_construction, :create_aliases

  def self.find_by_name(name)
    # prefer canonical name
    figure = find_by_canonical_name(name)
    return figure if figure

    # then, look for the first matching alias
    a = Alias.find_by_name(name)
    return a.figure if a

    # finally, look for the first matching construction name
    c = Construction.find_by_name(name)
    return c.figure if c

    nil
  end

  def illustration_path
    hi, lo = id.divmod(100)
    File.join(hi.to_s, lo.to_s)
  end

  private # --------------------------------------------------------------

  def create_construction
    return unless @construction
    constructions.create(@construction.merge(:submitter_id => submitter_id))
    @construction = nil
  end

  def create_aliases
    return unless @new_aliases
    @new_aliases.each { |data| aliases.create!(data) if data[:name].present? }
    @new_aliases = nil
  end
end
