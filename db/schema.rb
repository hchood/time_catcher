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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140114183627) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: true do |t|
    t.string   "name",                           null: false
    t.text     "description"
    t.integer  "time_needed_in_min",             null: false
    t.integer  "user_id",                        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "category_id"
    t.integer  "skipped_count",      default: 0
    t.integer  "completed_count",    default: 0
  end

  add_index "activities", ["name", "user_id"], name: "index_activities_on_name_and_user_id", unique: true, using: :btree

  create_table "activity_selections", force: true do |t|
    t.integer  "activity_id",         null: false
    t.integer  "activity_session_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "activity_sessions", force: true do |t|
    t.integer  "activity_id",         null: false
    t.integer  "time_available",      null: false
    t.datetime "finished_at"
    t.integer  "duration_in_seconds"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "start_time"
    t.integer  "user_id"
  end

  create_table "categories", force: true do |t|
    t.string  "name",    null: false
    t.integer "user_id"
  end

  add_index "categories", ["name", "user_id"], name: "index_categories_on_name_and_user_id", unique: true, using: :btree

  create_table "contacts", force: true do |t|
    t.string "first_name",  null: false
    t.string "last_name",   null: false
    t.string "subject",     null: false
    t.string "description", null: false
    t.string "email",       null: false
  end

  add_index "contacts", ["email"], name: "index_contacts_on_email", using: :btree

  create_table "users", force: true do |t|
    t.string   "first_name",                          null: false
    t.string   "last_name",                           null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
