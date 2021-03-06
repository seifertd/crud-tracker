# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111220174607) do

  create_table "entrants", :force => true do |t|
    t.integer  "game_id",                          :null => false
    t.integer  "player_id",                        :null => false
    t.integer  "strikes",        :default => 0,    :null => false
    t.integer  "position",       :default => 1,    :null => false
    t.boolean  "alive",          :default => true, :null => false
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.integer  "final_position"
  end

  create_table "games", :force => true do |t|
    t.boolean  "started",    :default => false, :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "players", :force => true do |t|
    t.string   "name"
    t.string   "nickname"
    t.integer  "points"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.integer  "bonus_points", :default => 0,    :null => false
    t.boolean  "active",       :default => true, :null => false
  end

end
