# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2024_11_03_190746) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "availability_tutors", force: :cascade do |t|
    t.uuid "user_id", null: false
    t.bigint "topic_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["topic_id"], name: "index_availability_tutors_on_topic_id"
    t.index ["user_id"], name: "index_availability_tutors_on_user_id"
  end

  create_table "careers", force: :cascade do |t|
    t.string "name"
    t.bigint "university_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["university_id"], name: "index_careers_on_university_id"
  end

  create_table "interesteds", force: :cascade do |t|
    t.uuid "user_id", null: false
    t.bigint "availability_tutor_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["availability_tutor_id"], name: "index_interesteds_on_availability_tutor_id"
    t.index ["user_id"], name: "index_interesteds_on_user_id"
  end

  create_table "meets", force: :cascade do |t|
    t.datetime "date_time"
    t.string "link"
    t.string "status"
    t.bigint "availability_tutor_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "count_interesteds", default: 0
    t.index ["availability_tutor_id"], name: "index_meets_on_availability_tutor_id"
  end

  create_table "participants", force: :cascade do |t|
    t.bigint "meet_id", null: false
    t.uuid "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["meet_id"], name: "index_participants_on_meet_id"
    t.index ["user_id"], name: "index_participants_on_user_id"
  end

  create_table "student_topics", force: :cascade do |t|
    t.uuid "user_id", null: false
    t.bigint "topic_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["topic_id"], name: "index_student_topics_on_topic_id"
    t.index ["user_id"], name: "index_student_topics_on_user_id"
  end

  create_table "subjects", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "career_id"
    t.index ["career_id"], name: "index_subjects_on_career_id"
  end

  create_table "topics", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "subject_id", null: false
    t.string "image_url"
    t.string "link"
    t.boolean "show_email", default: false
    t.index ["subject_id"], name: "index_topics_on_subject_id"
  end

  create_table "universities", force: :cascade do |t|
    t.string "name"
    t.string "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "uid"
    t.string "description"
    t.string "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "ranking"
    t.integer "amount_given_lessons"
    t.integer "amount_given_topics"
    t.integer "amount_attended_students"
    t.integer "attended_lessons", default: 0
    t.integer "attended_tutors", default: 0
    t.integer "attended_topics", default: 0
    t.bigint "career_id"
    t.index ["career_id"], name: "index_users_on_career_id"
  end

  add_foreign_key "availability_tutors", "topics"
  add_foreign_key "availability_tutors", "users"
  add_foreign_key "careers", "universities"
  add_foreign_key "interesteds", "availability_tutors"
  add_foreign_key "interesteds", "users"
  add_foreign_key "meets", "availability_tutors"
  add_foreign_key "participants", "meets"
  add_foreign_key "participants", "users"
  add_foreign_key "student_topics", "topics"
  add_foreign_key "student_topics", "users"
  add_foreign_key "subjects", "careers"
  add_foreign_key "topics", "subjects"
  add_foreign_key "users", "careers"
end
