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

ActiveRecord::Schema.define(:version => 20130222210156) do

  create_table "accounts", :force => true do |t|
    t.string   "business",        :null => false
    t.string   "contact"
    t.integer  "age"
    t.date     "last_contact_on"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "bulky_bulk_updates", :force => true do |t|
    t.text     "ids",                                :null => false
    t.text     "updates",                            :null => false
    t.integer  "initiated_by_id"
    t.boolean  "notified",        :default => false, :null => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  add_index "bulky_bulk_updates", ["initiated_by_id"], :name => "index_bulky_bulk_updates_on_initiated_by_id"

  create_table "bulky_updated_records", :force => true do |t|
    t.integer  "bulk_update_id",                       :null => false
    t.integer  "updatable_id",                         :null => false
    t.string   "updatable_type",                       :null => false
    t.text     "updatable_changes",                    :null => false
    t.string   "error_message"
    t.text     "error_backtrace"
    t.boolean  "completed",         :default => false, :null => false
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

  add_index "bulky_updated_records", ["bulk_update_id"], :name => "index_bulky_updated_records_on_bulk_update_id"
  add_index "bulky_updated_records", ["updatable_type", "updatable_id"], :name => "index_bulky_updated_records_on_updatable_type_and_updatable_id"

end
