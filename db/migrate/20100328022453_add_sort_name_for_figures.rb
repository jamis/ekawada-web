class AddSortNameForFigures < ActiveRecord::Migration
  def self.up
    add_column :figures, :sort_name, :string

    Figure.all.each do |figure|
      figure.canonical_name_will_change!
      figure.save!
    end

    add_index :figures, :sort_name
  end

  def self.down
    remove_column :figures, :sort_name, :string
  end
end
