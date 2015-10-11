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

ActiveRecord::Schema.define(:version => 20140923085114) do

  create_table "admin_profiles", :force => true do |t|
    t.string   "about"
    t.string   "position"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "admin_id"
    t.integer  "super_user_id"
    t.text     "address"
    t.text     "city"
    t.text     "zipcode"
    t.text     "state"
  end

  add_index "admin_profiles", ["admin_id"], :name => "index_admin_profiles_on_admin_id"
  add_index "admin_profiles", ["super_user_id"], :name => "index_admin_profiles_on_super_user_id"

  create_table "crowdfunds", :force => true do |t|
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "goal"
    t.integer  "pledged_total"
    t.integer  "grant_id"
    t.boolean  "eighty"
    t.boolean  "finished"
  end

  add_index "crowdfunds", ["grant_id"], :name => "index_crowdfunds_on_grant_id"

  create_table "draft_grants", :force => true do |t|
    t.integer  "recipient_id"
    t.text     "title"
    t.text     "summary"
    t.text     "subject_areas"
    t.text     "grade_level"
    t.text     "duration"
    t.integer  "num_classes"
    t.integer  "num_students"
    t.integer  "total_budget"
    t.text     "funds_will_pay_for"
    t.text     "budget_desc"
    t.text     "purpose"
    t.text     "methods"
    t.text     "background"
    t.integer  "n_collaborators"
    t.text     "collaborators"
    t.text     "comments"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "video"
    t.string   "image"
    t.integer  "school_id"
    t.string   "type"
    t.integer  "grant_id"
  end

  add_index "draft_grants", ["grant_id"], :name => "index_draft_grants_on_grant_id"
  add_index "draft_grants", ["recipient_id"], :name => "index_draft_grants_on_recipient_id"
  add_index "draft_grants", ["school_id"], :name => "index_draft_grants_on_school_id"

  create_table "grants", :force => true do |t|
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.text     "title"
    t.text     "summary"
    t.text     "subject_areas"
    t.text     "grade_level"
    t.text     "duration"
    t.integer  "num_classes"
    t.integer  "num_students"
    t.integer  "total_budget"
    t.text     "funds_will_pay_for"
    t.text     "budget_desc"
    t.text     "purpose"
    t.text     "methods"
    t.text     "background"
    t.integer  "n_collaborators"
    t.text     "collaborators"
    t.text     "comments"
    t.integer  "recipient_id"
    t.string   "state"
    t.string   "video"
    t.string   "image"
    t.integer  "school_id"
    t.string   "school_name"
    t.string   "teacher_name"
    t.string   "type"
    t.date     "deadline"
    t.text     "other_funds"
  end

  add_index "grants", ["recipient_id"], :name => "index_grants_on_recipient_id"
  add_index "grants", ["school_id"], :name => "index_grants_on_school_id"

  create_table "payments", :force => true do |t|
    t.integer  "amount"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "user_id"
    t.integer  "crowdfund_id"
    t.string   "charge_id"
    t.text     "status"
  end

  add_index "payments", ["crowdfund_id"], :name => "index_payments_on_crowdfund_id"
  add_index "payments", ["user_id"], :name => "index_payments_on_user_id"

  create_table "phrasing_phrase_versions", :force => true do |t|
    t.integer  "phrasing_phrase_id"
    t.text     "value"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "phrasing_phrase_versions", ["phrasing_phrase_id"], :name => "index_phrasing_phrase_versions_on_phrasing_phrase_id"

  create_table "phrasing_phrases", :force => true do |t|
    t.string   "locale"
    t.string   "key"
    t.text     "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "recipient_profiles", :force => true do |t|
    t.integer  "school_id"
    t.text     "about"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "recipient_id"
    t.datetime "started_teaching"
    t.string   "subject"
    t.string   "grade"
    t.string   "address"
    t.string   "city"
    t.text     "zipcode"
    t.string   "work_phone"
    t.string   "home_phone"
    t.text     "state"
  end

  add_index "recipient_profiles", ["school_id"], :name => "index_recipient_profiles_on_school_id"

  create_table "schools", :force => true do |t|
    t.string   "name"
    t.integer  "donations_received"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "simple_captcha_data", :force => true do |t|
    t.string   "key",        :limit => 40
    t.string   "value",      :limit => 6
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "simple_captcha_data", ["key"], :name => "idx_key"

  create_table "user_profiles", :force => true do |t|
    t.text     "address"
    t.text     "city"
    t.text     "zipcode"
    t.text     "phone"
    t.text     "relationship"
    t.integer  "user_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "state"
  end

  add_index "user_profiles", ["user_id"], :name => "index_user_profiles_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "type"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "stripe_token"
    t.boolean  "approved"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "versions", :force => true do |t|
    t.string   "item_type",  :null => false
    t.integer  "item_id",    :null => false
    t.string   "event",      :null => false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], :name => "index_versions_on_item_type_and_item_id"

end
