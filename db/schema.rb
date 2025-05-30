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

ActiveRecord::Schema[8.0].define(version: 2025_05_30_015312) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "audit_logs", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "action"
    t.string "auditable_type", null: false
    t.bigint "auditable_id", null: false
    t.jsonb "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["auditable_type", "auditable_id"], name: "index_audit_logs_on_auditable"
    t.index ["user_id"], name: "index_audit_logs_on_user_id"
  end

  create_table "bank_accounts", force: :cascade do |t|
    t.string "account_number"
    t.decimal "balance"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "agency", null: false
    t.index ["agency"], name: "index_bank_accounts_on_agency"
    t.index ["user_id"], name: "index_bank_accounts_on_user_id"
  end

  create_table "scheduled_transactions", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.bigint "source_account_id", null: false
    t.bigint "destination_account_id", null: false
    t.datetime "scheduled_for", null: false
    t.string "description"
    t.string "status", default: "pending", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["destination_account_id"], name: "index_scheduled_transactions_on_destination_account_id"
    t.index ["scheduled_for"], name: "index_scheduled_transactions_on_scheduled_for"
    t.index ["source_account_id"], name: "index_scheduled_transactions_on_source_account_id"
    t.index ["status"], name: "index_scheduled_transactions_on_status"
  end

  create_table "transactions", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.string "transaction_type", null: false
    t.bigint "source_account_id", null: false
    t.bigint "destination_account_id", null: false
    t.string "status", default: "pending", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description"
    t.index ["destination_account_id"], name: "index_transactions_on_destination_account_id"
    t.index ["source_account_id"], name: "index_transactions_on_source_account_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.string "name"
    t.string "cpf"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin"
  end

  add_foreign_key "audit_logs", "users"
  add_foreign_key "bank_accounts", "users"
  add_foreign_key "scheduled_transactions", "bank_accounts", column: "destination_account_id"
  add_foreign_key "scheduled_transactions", "bank_accounts", column: "source_account_id"
  add_foreign_key "transactions", "bank_accounts", column: "destination_account_id"
  add_foreign_key "transactions", "bank_accounts", column: "source_account_id"
end
