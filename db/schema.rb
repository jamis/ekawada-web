# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100321144234) do

  create_table "aliases", :force => true do |t|
    t.integer  "figure_id",  :null => false
    t.string   "name",       :null => false
    t.text     "location"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "aliases", ["figure_id"], :name => "index_aliases_on_figure_id"

  create_table "constructions", :force => true do |t|
    t.string   "name"
    t.integer  "figure_id",    :null => false
    t.string   "notation_id",  :null => false
    t.integer  "submitter_id", :null => false
    t.text     "definition",   :null => false
    t.datetime "reviewed_at"
    t.integer  "reviewed_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
  end

  add_index "constructions", ["figure_id"], :name => "index_constructions_on_figure_id"
  add_index "constructions", ["notation_id"], :name => "index_constructions_on_notation_id"
  add_index "constructions", ["submitter_id"], :name => "index_constructions_on_submitter_id"

  create_table "figure_sources", :force => true do |t|
    t.integer  "figure_id", :null => false
    t.integer  "source_id", :null => false
    t.text     "info"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "figure_sources", ["figure_id"], :name => "index_figure_sources_on_figure_id"
  add_index "figure_sources", ["source_id"], :name => "index_figure_sources_on_source_id"

  create_table "figures", :force => true do |t|
    t.string   "canonical_name", :null => false
    t.boolean  "opening"
    t.boolean  "ending"
    t.boolean  "maneuver"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
  end

  add_index "figures", ["updated_at"], :name => "index_figures_on_updated_at"

  create_table "illustrations", :force => true do |t|
    t.string   "parent_type", :null => false
    t.integer  "parent_id",   :null => false
    t.string   "caption"
    t.integer  "width"
    t.integer  "height"
    t.string   "extension"
    t.integer  "file_size"
    t.integer  "number"
    t.string   "location"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "illustrations", ["parent_type", "parent_id", "number"], :name => "index_illustrations_on_parent_type_and_parent_id_and_number", :unique => true

  create_table "references", :force => true do |t|
    t.integer  "construction_id",  :null => false
    t.integer  "figure_source_id", :null => false
    t.text     "info"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "references", ["construction_id"], :name => "index_references_on_construction_id"
  add_index "references", ["figure_source_id"], :name => "index_references_on_figure_source_id"

  create_table "sources", :force => true do |t|
    t.string   "type"
    t.text     "info"
    t.string   "sorting"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sources", ["sorting"], :name => "index_sources_on_sorting"

  create_table "steps", :force => true do |t|
    t.integer  "construction_id", :null => false
    t.integer  "position",        :null => false
    t.text     "instruction"
    t.text     "comment"
    t.string   "name"
    t.integer  "figure_id"
    t.string   "duplicate_type"
    t.integer  "duplicate_id"
    t.integer  "duplicate_from"
    t.integer  "duplicate_to"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "steps", ["construction_id", "position"], :name => "index_steps_on_construction_id_and_position"
  add_index "steps", ["figure_id"], :name => "index_steps_on_figure_id"

  create_table "users", :force => true do |t|
    t.string   "name",            :null => false
    t.string   "login"
    t.string   "email"
    t.string   "password_digest"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
