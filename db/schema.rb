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

ActiveRecord::Schema.define(:version => 20100326171805) do

  create_table "beta_codes", :force => true do |t|
    t.string   "code"
    t.boolean  "used",            :default => false
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
    t.datetime "last_boosted_at"
  end

  create_table "check_lists", :force => true do |t|
    t.string   "title"
    t.integer  "station_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "convocation_firemen", :force => true do |t|
    t.integer  "convocation_id"
    t.integer  "fireman_id"
    t.boolean  "presence",       :default => false
    t.integer  "grade"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "convocations", :force => true do |t|
    t.string   "title"
    t.datetime "date"
    t.integer  "uniform_id"
    t.integer  "station_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "place"
    t.text     "rem"
  end

  create_table "fireman_interventions", :force => true do |t|
    t.integer  "fireman_id"
    t.integer  "intervention_id"
    t.integer  "grade"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "firemen", :force => true do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.integer  "station_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "grade"
    t.integer  "status"
    t.integer  "grade_category"
    t.date     "birthday"
    t.text     "rem"
    t.boolean  "chief"
    t.boolean  "chief_assistant"
    t.boolean  "quartermaster"
  end

  create_table "grades", :force => true do |t|
    t.integer "fireman_id"
    t.integer "kind"
    t.date    "date"
  end

  create_table "intervention_vehicles", :force => true do |t|
    t.integer  "intervention_id"
    t.integer  "vehicle_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "interventions", :force => true do |t|
    t.integer  "station_id"
    t.integer  "kind"
    t.string   "number"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "place"
    t.text     "rem"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "quantity"
    t.date     "expiry"
    t.text     "rem"
    t.integer  "check_list_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "place"
  end

  create_table "messages", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "read_at"
  end

  create_table "newsletters", :force => true do |t|
    t.string   "email"
    t.string   "activation_key",  :limit => 64
    t.datetime "activated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "invited_at"
    t.datetime "last_boosted_at"
  end

  create_table "stations", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "last_grade_update_at"
  end

  create_table "typus_users", :force => true do |t|
    t.string   "first_name",       :default => "",    :null => false
    t.string   "last_name",        :default => "",    :null => false
    t.string   "role",                                :null => false
    t.string   "email",                               :null => false
    t.boolean  "status",           :default => false
    t.string   "token",                               :null => false
    t.string   "salt",                                :null => false
    t.string   "crypted_password",                    :null => false
    t.string   "preferences"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "uniforms", :force => true do |t|
    t.string   "title"
    t.string   "description"
    t.integer  "station_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "code"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.string   "perishable_token"
    t.integer  "login_count",          :default => 0, :null => false
    t.integer  "failed_login_count",   :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.integer  "station_id"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_boosted_at"
  end

  create_table "vehicles", :force => true do |t|
    t.string   "name"
    t.integer  "station_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
