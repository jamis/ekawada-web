class AddDescriptions < ActiveRecord::Migration
  def self.up
    add_column :figures, :description, :text
    add_column :constructions, :description, :text
  end

  def self.down
    remove_column :figures, :description
    remove_column :constructions, :description
  end
end
