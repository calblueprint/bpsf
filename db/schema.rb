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

ActiveRecord::Schema.define(:version => 20131029075542) do

  create_table "crowdfunds", :force => true do |t|
    t.datetime "deadline"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "goal"
    t.integer  "pledged_total"
  end

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
    t.integer  "requested_funds"
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
    t.string   "image_url"
    t.integer  "school_id"
  end

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
    t.integer  "requested_funds"
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
    t.string   "image_url"
    t.integer  "school_id"
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
  end

  add_index "payments", ["crowdfund_id"], :name => "index_payments_on_crowdfund_id"
  add_index "payments", ["user_id"], :name => "index_payments_on_user_id"

  create_table "schools", :force => true do |t|
    t.string   "name"
    t.integer  "donations_received"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

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
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
