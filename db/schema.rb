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

ActiveRecord::Schema.define(version: 20190607060837) do

  create_table "applications", force: :cascade do |t|
    t.integer "experience"
    t.string "role"
    t.integer "candidate_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "resume"
    t.string "status", default: "open"
    t.index ["candidate_id", "role"], name: "index_applications_on_candidate_id_and_role", unique: true
    t.index ["candidate_id"], name: "index_applications_on_candidate_id"
  end

  create_table "candidates", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_candidates_on_email", unique: true
  end

  create_table "employees", force: :cascade do |t|
    t.string "name"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "interviews", force: :cascade do |t|
    t.string "round_name"
    t.date "scheduled_on"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer "interviewer_id"
    t.integer "application_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["application_id"], name: "index_interviews_on_application_id"
    t.index ["interviewer_id", "application_id", "start_time", "end_time"], name: "by_interviewier_and_application", unique: true
  end

end
