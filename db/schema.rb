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

ActiveRecord::Schema[7.1].define(version: 2025_04_02_053823) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bookings", force: :cascade do |t|
    t.date "start_date"
    t.date "end_date"
    t.integer "num_nights"
    t.integer "num_guests"
    t.decimal "cabin_price"
    t.decimal "extras_price"
    t.decimal "total_price"
    t.boolean "has_breakfast"
    t.text "observations"
    t.boolean "is_paid"
    t.bigint "cabin_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["cabin_id"], name: "index_bookings_on_cabin_id"
    t.index ["user_id"], name: "index_bookings_on_user_id"
  end

  create_table "cabins", force: :cascade do |t|
    t.integer "max_capacity"
    t.integer "regular_price"
    t.integer "discount"
    t.text "description"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "settings", force: :cascade do |t|
    t.integer "min_booking_length"
    t.integer "max_booking_length"
    t.integer "max_guests_per_booking"
    t.decimal "breakfast_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "full_name"
    t.string "jti", null: false
    t.string "role", default: "guest"
    t.string "nationality"
    t.string "country_flag"
    t.string "national_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "bookings", "cabins"
  add_foreign_key "bookings", "users"
end
