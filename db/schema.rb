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

ActiveRecord::Schema.define(version: 20130115205046) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "household_membership_audits", force: :cascade do |t|
    t.integer  "household_id"
    t.integer  "member_id"
    t.string   "event",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "households", force: :cascade do |t|
    t.decimal  "balance",    precision: 8, scale: 2, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "notes"
  end

  create_table "members", force: :cascade do |t|
    t.string   "last_name",    limit: 255
    t.string   "first_name",   limit: 255
    t.integer  "household_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "phone1",       limit: 255
    t.string   "phone2",       limit: 255
    t.string   "address1",     limit: 255
    t.string   "address2",     limit: 255
    t.string   "city",         limit: 255
    t.string   "state",        limit: 255
    t.string   "zip",          limit: 255
    t.text     "notes"
    t.boolean  "active",                   default: true
    t.string   "email",        limit: 255
  end

  create_table "transactions", force: :cascade do |t|
    t.decimal  "amount",                   precision: 8, scale: 2,                 null: false
    t.boolean  "credit",                                                           null: false
    t.string   "message",      limit: 255
    t.integer  "household_id",                                                     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "void",                                             default: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                limit: 255, default: "", null: false
    t.string   "encrypted_password",   limit: 128, default: "", null: false
    t.string   "password_salt",        limit: 255, default: "", null: false
    t.string   "reset_password_token", limit: 255
    t.string   "remember_token",       limit: 255
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                    default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",   limit: 255
    t.string   "last_sign_in_ip",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
