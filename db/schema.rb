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

ActiveRecord::Schema.define(version: 20160410191405) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "apps", force: :cascade do |t|
    t.string   "name"
    t.string   "app_id"
    t.string   "api_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "calls", force: :cascade do |t|
    t.string   "uuid"
    t.string   "caller_id"
    t.string   "caller_name"
    t.string   "status"
    t.integer  "company_number_id"
    t.integer  "user_number_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "hangup_case"
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "answer_time"
  end

  add_index "calls", ["company_number_id"], name: "index_calls_on_company_number_id", using: :btree
  add_index "calls", ["user_number_id"], name: "index_calls_on_user_number_id", using: :btree

  create_table "company_numbers", force: :cascade do |t|
    t.string   "sip_endpoint"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "sip_endpoint_id"
    t.string   "password"
    t.integer  "app_id"
  end

  add_index "company_numbers", ["app_id"], name: "index_company_numbers_on_app_id", using: :btree

  create_table "user_numbers", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "sip_endpoint"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "sip_endpoint_id"
    t.string   "password"
  end

  add_index "user_numbers", ["user_id"], name: "index_user_numbers_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "app_id"
  end

  add_index "users", ["app_id"], name: "index_users_on_app_id", using: :btree

  create_table "voice_mails", force: :cascade do |t|
    t.string   "url"
    t.integer  "duration"
    t.integer  "call_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "voice_mails", ["call_id"], name: "index_voice_mails_on_call_id", using: :btree

  add_foreign_key "voice_mails", "calls"
end
