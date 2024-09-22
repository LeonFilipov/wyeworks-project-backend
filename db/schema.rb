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

ActiveRecord::Schema[7.2].define(version: 2024_09_22_002556) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "availability_tutors", force: :cascade do |t|
    t.bigint "tutor_id", null: false
    t.string "description"
    t.datetime "tentative_date_from"
    t.datetime "tentative_date_to"
    t.datetime "effective_date"
    t.string "link"
    t.string "form"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tutor_id"], name: "index_availability_tutors_on_tutor_id"
  end

  create_table "given_topics", force: :cascade do |t|
    t.bigint "tutor_id", null: false
    t.bigint "topic_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["topic_id"], name: "index_given_topics_on_topic_id"
    t.index ["tutor_id"], name: "index_given_topics_on_tutor_id"
  end

  create_table "subjects", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "university_id", null: false
    t.index ["university_id"], name: "index_subjects_on_university_id"
  end

  create_table "topics", force: :cascade do |t|
    t.string "name"
    t.text "asset"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "subject_id", null: false
    t.index ["subject_id"], name: "index_topics_on_subject_id"
  end

  create_table "tutors", force: :cascade do |t|
    t.uuid "user_id", null: false
    t.integer "ranking"
    t.integer "amount_given_lessons"
    t.integer "amount_given_topics"
    t.integer "amount_attended_students"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_tutors_on_user_id"
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
  end

  add_foreign_key "availability_tutors", "tutors"
  add_foreign_key "given_topics", "topics"
  add_foreign_key "given_topics", "tutors"
  add_foreign_key "subjects", "universities"
  add_foreign_key "topics", "subjects"
  add_foreign_key "tutors", "users"
end
