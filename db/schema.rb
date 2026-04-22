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

ActiveRecord::Schema[8.1].define(version: 2026_04_20_092559) do
  create_table "audit_logs", force: :cascade do |t|
    t.string "action"
    t.datetime "created_at", null: false
    t.string "from_status"
    t.integer "repair_request_id"
    t.string "to_status"
    t.datetime "updated_at", null: false
    t.integer "user_id"
  end

  create_table "jwt_denylists", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "exp"
    t.string "jti"
    t.datetime "updated_at", null: false
  end

  create_table "repair_requests", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "customer_id"
    t.decimal "price_quotation"
    t.text "problem_description"
    t.string "status"
    t.datetime "updated_at", null: false
    t.string "vehicle_details"
    t.integer "workshop_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.string "role"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end
end
