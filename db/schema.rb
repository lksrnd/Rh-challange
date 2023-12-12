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

ActiveRecord::Schema.define(version: 20230802142849) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contacts", force: :cascade do |t|
    t.string "phone"
    t.string "mobile_phone"
    t.string "email"
    t.bigint "employee_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_contacts_on_email", unique: true
    t.index ["employee_id"], name: "index_contacts_on_employee_id"
  end

  create_table "employees", force: :cascade do |t|
    t.string "full_name"
    t.date "birth_date"
    t.string "origin_city"
    t.string "home_state"
    t.string "marital_status"
    t.string "sex"
    t.bigint "workspace_id"
    t.bigint "job_role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_role_id"], name: "index_employees_on_job_role_id"
    t.index ["workspace_id"], name: "index_employees_on_workspace_id"
  end

  create_table "job_roles", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "workspaces", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "contacts", "employees"
  add_foreign_key "employees", "job_roles"
  add_foreign_key "employees", "workspaces"
end
