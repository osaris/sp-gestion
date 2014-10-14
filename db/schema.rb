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

ActiveRecord::Schema.define(version: 20141014115444) do

  create_table "check_lists", force: true do |t|
    t.string   "title",      limit: 255
    t.integer  "station_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "check_lists", ["station_id"], name: "index_check_lists_on_station_id", using: :btree

  create_table "convocation_firemen", force: true do |t|
    t.integer  "convocation_id", limit: 4
    t.integer  "fireman_id",     limit: 4
    t.boolean  "presence",       limit: 1, default: false
    t.integer  "grade",          limit: 4
    t.integer  "status",         limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "convocation_firemen", ["convocation_id"], name: "index_convocation_firemen_on_convocation_id", using: :btree
  add_index "convocation_firemen", ["fireman_id"], name: "index_convocation_firemen_on_fireman_id", using: :btree

  create_table "convocations", force: true do |t|
    t.string   "title",           limit: 255
    t.datetime "date"
    t.integer  "uniform_id",      limit: 4
    t.integer  "station_id",      limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "place",           limit: 255
    t.text     "rem",             limit: 65535
    t.boolean  "hide_grade",      limit: 1,     default: false
    t.datetime "last_emailed_at"
    t.boolean  "confirmable",     limit: 1
  end

  add_index "convocations", ["station_id"], name: "index_convocations_on_station_id", using: :btree
  add_index "convocations", ["uniform_id"], name: "index_convocations_on_uniform_id", using: :btree

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   limit: 4,     default: 0
    t.integer  "attempts",   limit: 4,     default: 0
    t.text     "handler",    limit: 65535
    t.text     "last_error", limit: 65535
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "queue",      limit: 255
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "fireman_availabilities", force: true do |t|
    t.integer  "fireman_id",   limit: 4
    t.integer  "station_id",   limit: 4
    t.datetime "availability"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fireman_interventions", force: true do |t|
    t.integer  "fireman_id",           limit: 4
    t.integer  "intervention_id",      limit: 4
    t.integer  "grade",                limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "intervention_role_id", limit: 4
  end

  add_index "fireman_interventions", ["fireman_id"], name: "index_fireman_interventions_on_fireman_id", using: :btree
  add_index "fireman_interventions", ["intervention_id"], name: "index_fireman_interventions_on_intervention_id", using: :btree
  add_index "fireman_interventions", ["intervention_role_id"], name: "index_fireman_interventions_on_intervention_role_id", using: :btree

  create_table "fireman_trainings", force: true do |t|
    t.integer  "fireman_id",  limit: 4
    t.integer  "training_id", limit: 4
    t.date     "achieved_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "rem",         limit: 16777215
    t.integer  "station_id",  limit: 4
  end

  add_index "fireman_trainings", ["fireman_id"], name: "index_fireman_trainings_on_fireman_id", using: :btree
  add_index "fireman_trainings", ["station_id"], name: "index_fireman_trainings_on_station_id", using: :btree
  add_index "fireman_trainings", ["training_id"], name: "index_fireman_trainings_on_training_id", using: :btree

  create_table "firemen", force: true do |t|
    t.string   "firstname",          limit: 255
    t.string   "lastname",           limit: 255
    t.integer  "station_id",         limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "grade",              limit: 4
    t.integer  "status",             limit: 4
    t.integer  "grade_category",     limit: 4
    t.date     "birthday"
    t.text     "rem",                limit: 65535
    t.date     "checkup"
    t.string   "cached_tag_list",    limit: 255
    t.string   "email",              limit: 255
    t.string   "passeport_photo",    limit: 255
    t.string   "regimental_number",  limit: 255
    t.date     "incorporation_date"
    t.date     "resignation_date"
    t.date     "checkup_truck"
  end

  add_index "firemen", ["station_id"], name: "index_firemen_on_station_id", using: :btree

  create_table "grades", force: true do |t|
    t.integer "fireman_id", limit: 4
    t.integer "kind",       limit: 4
    t.date    "date"
  end

  add_index "grades", ["fireman_id"], name: "index_grades_on_fireman_id", using: :btree

  create_table "groups", force: true do |t|
    t.integer  "station_id", limit: 4
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "intervention_roles", force: true do |t|
    t.integer  "station_id", limit: 4
    t.string   "name",       limit: 255
    t.string   "short_name", limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "intervention_roles", ["station_id"], name: "index_intervention_roles_on_station_id", using: :btree

  create_table "intervention_vehicles", force: true do |t|
    t.integer  "intervention_id", limit: 4
    t.integer  "vehicle_id",      limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "intervention_vehicles", ["intervention_id"], name: "index_intervention_vehicles_on_intervention_id", using: :btree
  add_index "intervention_vehicles", ["vehicle_id"], name: "index_intervention_vehicles_on_vehicle_id", using: :btree

  create_table "interventions", force: true do |t|
    t.integer  "station_id", limit: 4
    t.integer  "kind",       limit: 4
    t.string   "number",     limit: 255
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "place",      limit: 255
    t.text     "rem",        limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "city",       limit: 255
    t.float    "latitude",   limit: 24
    t.float    "longitude",  limit: 24
    t.string   "subkind",    limit: 255
  end

  add_index "interventions", ["station_id"], name: "index_interventions_on_station_id", using: :btree

  create_table "items", force: true do |t|
    t.string   "title",         limit: 255
    t.text     "description",   limit: 65535
    t.integer  "quantity",      limit: 4
    t.date     "expiry"
    t.text     "rem",           limit: 65535
    t.integer  "check_list_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "place",         limit: 255
    t.string   "item_photo",    limit: 255
  end

  add_index "items", ["check_list_id"], name: "index_items_on_check_list_id", using: :btree

  create_table "messages", force: true do |t|
    t.integer  "user_id",    limit: 4
    t.string   "title",      limit: 255
    t.text     "body",       limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "read_at"
  end

  add_index "messages", ["user_id"], name: "index_messages_on_user_id", using: :btree

  create_table "permissions", force: true do |t|
    t.integer  "group_id",    limit: 4
    t.integer  "resource_id", limit: 4
    t.boolean  "can_read",    limit: 1
    t.boolean  "can_create",  limit: 1
    t.boolean  "can_update",  limit: 1
    t.boolean  "can_destroy", limit: 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "resources", force: true do |t|
    t.string   "title",      limit: 255
    t.string   "name",       limit: 255
    t.string   "category",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stations", force: true do |t|
    t.string   "name",                          limit: 255
    t.string   "url",                           limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "intervention_editable_at"
    t.integer  "owner_id",                      limit: 4
    t.datetime "last_email_sent_at"
    t.integer  "nb_email_sent",                 limit: 4,   default: 0
    t.string   "logo",                          limit: 255
    t.boolean  "interventions_number_per_year", limit: 1,   default: false
    t.integer  "interventions_number_size",     limit: 4,   default: 0
    t.boolean  "demo",                          limit: 1
  end

  add_index "stations", ["url"], name: "index_stations_on_url", using: :btree

  create_table "taggings", force: true do |t|
    t.integer  "tag_id",        limit: 4
    t.integer  "taggable_id",   limit: 4
    t.integer  "tagger_id",     limit: 4
    t.string   "tagger_type",   limit: 255
    t.string   "taggable_type", limit: 255
    t.string   "context",       limit: 255
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree
  add_index "taggings", ["tagger_id"], name: "index_taggings_on_tagger_id", using: :btree
  add_index "taggings", ["tagger_type"], name: "index_taggings_on_tagger_type", using: :btree

  create_table "tags", force: true do |t|
    t.string  "name",           limit: 255
    t.integer "taggings_count", limit: 4,   default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "trainings", force: true do |t|
    t.integer  "station_id",  limit: 4
    t.string   "name",        limit: 255
    t.string   "short_name",  limit: 255
    t.text     "description", limit: 16777215
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "trainings", ["station_id"], name: "index_trainings_on_station_id", using: :btree

  create_table "uniforms", force: true do |t|
    t.string   "code",        limit: 255
    t.string   "title",       limit: 255
    t.string   "description", limit: 255
    t.integer  "station_id",  limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "uniforms", ["station_id"], name: "index_uniforms_on_station_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                limit: 255
    t.string   "crypted_password",     limit: 255
    t.string   "password_salt",        limit: 255
    t.string   "persistence_token",    limit: 255
    t.string   "perishable_token",     limit: 255
    t.integer  "login_count",          limit: 4,   default: 0, null: false
    t.integer  "failed_login_count",   limit: 4,   default: 0, null: false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip",     limit: 255
    t.string   "last_login_ip",        limit: 255
    t.integer  "station_id",           limit: 4
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "new_email",            limit: 255
    t.integer  "group_id",             limit: 4
  end

  add_index "users", ["station_id"], name: "index_users_on_station_id", using: :btree

  create_table "vehicles", force: true do |t|
    t.string   "name",           limit: 255
    t.integer  "station_id",     limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "rem",            limit: 65535
    t.date     "date_approval"
    t.date     "date_check"
    t.date     "date_review"
    t.string   "vehicle_photo",  limit: 255
    t.date     "date_delisting"
  end

  add_index "vehicles", ["station_id"], name: "index_vehicles_on_station_id", using: :btree

end
