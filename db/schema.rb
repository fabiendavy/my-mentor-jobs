# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_05_21_091732) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "fields", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "levels", force: :cascade do |t|
    t.string "grade"
    t.string "cycle"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "requests", force: :cascade do |t|
    t.string "client_name"
    t.bigint "field_id", null: false
    t.bigint "level_id", null: false
    t.bigint "teacher_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["field_id"], name: "index_requests_on_field_id"
    t.index ["level_id"], name: "index_requests_on_level_id"
    t.index ["teacher_id"], name: "index_requests_on_teacher_id"
  end

  create_table "skills", force: :cascade do |t|
    t.bigint "field_id", null: false
    t.bigint "level_id", null: false
    t.bigint "teacher_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["field_id"], name: "index_skills_on_field_id"
    t.index ["level_id"], name: "index_skills_on_level_id"
    t.index ["teacher_id"], name: "index_skills_on_teacher_id"
  end

  create_table "teachers", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "requests", "fields"
  add_foreign_key "requests", "levels"
  add_foreign_key "requests", "teachers"
  add_foreign_key "skills", "fields"
  add_foreign_key "skills", "levels"
  add_foreign_key "skills", "teachers"
end
