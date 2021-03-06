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

ActiveRecord::Schema.define(:version => 20120606223908) do

  create_table "accountings", :force => true do |t|
    t.string   "title"
    t.integer  "balance"
    t.integer  "event_id"
    t.integer  "activity_id"
    t.integer  "department_id"
    t.integer  "user_id"
    t.string   "receipt"
    t.text     "comment"
    t.boolean  "approved"
    t.boolean  "paid"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "activities", :force => true do |t|
    t.string   "act_name"
    t.integer  "act_head"
    t.integer  "event_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "act_subtitle"
    t.text     "act_description"
    t.text     "act_image_url"
    t.text     "music_url"
    t.string   "calendar_id"
    t.text     "doc_link"
  end

  create_table "departments", :force => true do |t|
    t.string   "dep_name"
    t.integer  "dep_head"
    t.integer  "event_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "dep_subtitle"
    t.text     "dep_description"
    t.text     "dep_image_url"
    t.string   "calendar_id"
  end

  create_table "events", :force => true do |t|
    t.string   "event_name"
    t.date     "event_start"
    t.date     "event_end"
    t.integer  "event_head"
    t.integer  "organization_id"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.string   "event_subtitle"
    t.text     "event_description"
    t.text     "event_image_url"
    t.string   "event_trailer_url"
    t.integer  "accounting_manager_id"
    t.string   "calendar_id"
  end

  create_table "light_repeats", :force => true do |t|
    t.integer  "activity_id"
    t.string   "name"
    t.float    "start"
    t.float    "end"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "light_repeats", ["activity_id"], :name => "index_light_repeats_on_activity_id"

  create_table "light_scripts", :force => true do |t|
    t.integer  "activity_id"
    t.float    "time"
    t.string   "move"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "light_scripts", ["activity_id"], :name => "index_light_scripts_on_activity_id"

  create_table "organizations", :force => true do |t|
    t.string   "org_name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "posts", :force => true do |t|
    t.integer  "event_id"
    t.integer  "dep_id"
    t.integer  "act_id"
    t.string   "title"
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "user_activities", :force => true do |t|
    t.integer  "user_id"
    t.integer  "activity_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "user_departments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "department_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "user_events", :force => true do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.string   "role"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "fb_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
