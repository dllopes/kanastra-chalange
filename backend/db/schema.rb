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

ActiveRecord::Schema[7.1].define(version: 2024_06_23_135140) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "debts", force: :cascade do |t|
    t.string "name", limit: 256, null: false
    t.integer "government_id", null: false
    t.string "email", limit: 100, null: false
    t.integer "debt_amount", null: false
    t.date "debt_due_date", null: false
    t.uuid "debt_id", null: false
    t.bigint "uploaded_file_id", null: false
    t.boolean "processed", default: false
    t.index ["uploaded_file_id"], name: "index_debts_on_uploaded_file_id"
  end

  create_table "uploaded_files", force: :cascade do |t|
    t.string "filename"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "debts", "uploaded_files"
end
