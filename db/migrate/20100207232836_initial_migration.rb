class InitialMigration < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name, :null => false
      t.string :login
      t.string :email
      t.string :password_digest
      t.string :salt
      t.timestamps
    end

    add_index :users, :login, :unique => true
    add_index :users, :email

    create_table :sources do |t|
      t.string :type
      t.text :info, :null => false, :default => "--- {}"
      t.timestamps
    end

    create_table :figures do |t|
      t.string :canonical_name, :null => false
      t.boolean :opening
      t.boolean :ending
      t.boolean :maneuver
      t.timestamps
    end

    add_index :figures, :updated_at

    create_table :figure_sources do |t|
      t.integer :figure_id, :null => false
      t.integer :source_id, :null => false
      t.text :info, :null => false, :default => "--- {}"
      t.timestamps
    end

    add_index :figure_sources, :figure_id
    add_index :figure_sources, :source_id

    create_table :aliases do |t|
      t.integer :figure_id, :null => false
      t.string  :name, :null => false
      t.text    :locations, :null => false, :default => "--- []"
      t.timestamps
    end

    add_index :aliases, :figure_id

    create_table :constructions do |t|
      t.string :name
      t.integer :figure_id, :null => false
      t.string :notation, :null => false
      t.integer :submitter_id, :null => false
      t.text :definition, :null => false

      t.datetime :reviewed_at
      t.integer :reviewed_by

      t.timestamps
    end

    add_index :constructions, :figure_id
    add_index :constructions, :notation
    add_index :constructions, :submitter_id

    create_table :references do |t|
      t.integer :construction_id, :null => false
      t.integer :figure_source_id, :null => false
      t.text :info
      t.timestamps
    end

    add_index :references, :construction_id
    add_index :references, :figure_source_id

    create_table :steps do |t|
      t.integer :construction_id, :null => false
      t.integer :position, :null => false
      t.text    :instruction
      t.text    :comment

      # intermediate figure
      t.string  :name
      t.integer :figure_id

      # external construction reference (e.g. same as steps 1-3 of X)
      t.string  :duplicate_type   # "make X", "same as [range] of X", etc.
      t.integer :duplicate_id
      t.integer :duplicate_from
      t.integer :duplicate_to

      t.timestamps
    end

    add_index :steps, %w(construction_id position)
    add_index :steps, :figure_id
  end

  def self.down
    drop_table :users
    drop_table :figures
    drop_table :constructions
    drop_table :construction_sources
    drop_table :sources
    drop_table :steps
    drop_table :pending_reviews
  end
end
