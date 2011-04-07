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

ActiveRecord::Schema.define(:version => 20110407203229) do

  create_table "check_lists", :force => true do |t|
    t.string   "title"
    t.integer  "station_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "check_lists", ["station_id"], :name => "index_check_lists_on_station_id"

  create_table "convocation_firemen", :force => true do |t|
    t.integer  "convocation_id"
    t.integer  "fireman_id"
    t.boolean  "presence",       :default => false
    t.integer  "grade"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "convocation_firemen", ["convocation_id"], :name => "index_convocation_firemen_on_convocation_id"
  add_index "convocation_firemen", ["fireman_id"], :name => "index_convocation_firemen_on_fireman_id"

  create_table "convocations", :force => true do |t|
    t.string   "title"
    t.datetime "date"
    t.integer  "uniform_id"
    t.integer  "station_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "place"
    t.text     "rem"
    t.boolean  "hide_grade",      :default => false
    t.datetime "last_emailed_at"
  end

  add_index "convocations", ["station_id"], :name => "index_convocations_on_station_id"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "fireman_interventions", :force => true do |t|
    t.integer  "fireman_id"
    t.integer  "intervention_id"
    t.integer  "grade"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "fireman_interventions", ["fireman_id"], :name => "index_fireman_interventions_on_fireman_id"
  add_index "fireman_interventions", ["intervention_id"], :name => "index_fireman_interventions_on_intervention_id"

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
    t.date     "checkup"
    t.string   "cached_tag_list"
    t.string   "email"
    t.string   "passeport_photo"
  end

  add_index "firemen", ["station_id"], :name => "index_firemen_on_station_id"

  create_table "geocodes", :force => true do |t|
    t.decimal "latitude",    :precision => 15, :scale => 12
    t.decimal "longitude",   :precision => 15, :scale => 12
    t.string  "query"
    t.string  "street"
    t.string  "locality"
    t.string  "region"
    t.string  "postal_code"
    t.string  "country"
    t.string  "precision"
  end

  add_index "geocodes", ["country"], :name => "geocodes_country_index"
  add_index "geocodes", ["latitude"], :name => "geocodes_latitude_index"
  add_index "geocodes", ["locality"], :name => "geocodes_locality_index"
  add_index "geocodes", ["longitude"], :name => "geocodes_longitude_index"
  add_index "geocodes", ["postal_code"], :name => "geocodes_postal_code_index"
  add_index "geocodes", ["precision"], :name => "geocodes_precision_index"
  add_index "geocodes", ["query"], :name => "geocodes_query_index", :unique => true
  add_index "geocodes", ["region"], :name => "geocodes_region_index"

  create_table "geocodings", :force => true do |t|
    t.integer "geocodable_id"
    t.integer "geocode_id"
    t.string  "geocodable_type"
  end

  add_index "geocodings", ["geocodable_id"], :name => "geocodings_geocodable_id_index"
  add_index "geocodings", ["geocodable_type"], :name => "geocodings_geocodable_type_index"
  add_index "geocodings", ["geocode_id"], :name => "geocodings_geocode_id_index"

  create_table "grades", :force => true do |t|
    t.integer "fireman_id"
    t.integer "kind"
    t.date    "date"
  end

  add_index "grades", ["fireman_id"], :name => "index_grades_on_fireman_id"

  create_table "intervention_vehicles", :force => true do |t|
    t.integer  "intervention_id"
    t.integer  "vehicle_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "intervention_vehicles", ["intervention_id"], :name => "index_intervention_vehicles_on_intervention_id"

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
    t.string   "city"
    t.float    "latitude"
    t.float    "longitude"
  end

  add_index "interventions", ["station_id"], :name => "index_interventions_on_station_id"

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

  add_index "items", ["check_list_id"], :name => "index_items_on_check_list_id"

  create_table "messages", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "read_at"
  end

  add_index "messages", ["user_id"], :name => "index_messages_on_user_id"

  create_table "stations", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "last_grade_update_at"
    t.integer  "owner_id"
    t.datetime "last_email_sent_at"
    t.integer  "nb_email_sent",        :default => 0
    t.string   "logo"
  end

  add_index "stations", ["url"], :name => "index_stations_on_url"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "taggable_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
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

  add_index "uniforms", ["station_id"], :name => "index_uniforms_on_station_id"

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
    t.string   "new_email"
  end

  create_table "vehicles", :force => true do |t|
    t.string   "name"
    t.integer  "station_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "rem"
    t.date     "date_approval"
    t.date     "date_check"
    t.date     "date_review"
  end

  add_index "vehicles", ["station_id"], :name => "index_vehicles_on_station_id"

end
