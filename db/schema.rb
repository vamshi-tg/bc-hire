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

ActiveRecord::Schema.define(version: 20190916163753) do

  create_table "applications", force: :cascade do |t|
    t.integer "experience"
    t.string "role"
    t.integer "candidate_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "resume"
    t.string "status", default: "Open"
    t.integer "owner_id"
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
    t.string "role", default: "Interviewer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "uid"
    t.string "email"
    t.string "name"
    t.string "picture"
    t.string "provider"
    t.string "google_token"
    t.string "refresh_token"
    t.integer "google_token_expires_at"
  end

  create_table "feedbacks", force: :cascade do |t|
    t.string "content"
    t.integer "interviewer_id"
    t.integer "interview_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["interview_id"], name: "index_feedbacks_on_interview_id"
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
    t.string "google_event_id"
    t.index ["application_id"], name: "index_interviews_on_application_id"
    t.index ["interviewer_id", "application_id", "start_time", "end_time"], name: "by_interviewier_and_application", unique: true
  end

  create_table "permissions", force: :cascade do |t|
    t.boolean "can_interview_round_1", default: false
    t.boolean "can_interview_round_2", default: false
    t.boolean "can_interview_round_3", default: false
    t.boolean "can_interview_round_4", default: false
    t.integer "employee_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_permissions_on_employee_id"
  end

  create_table "topic_feedbacks", force: :cascade do |t|
    t.string "name"
    t.string "positives"
    t.string "negatives"
    t.string "candidate_level"
    t.integer "interview_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["interview_id"], name: "index_topic_feedbacks_on_interview_id"
  end

end
