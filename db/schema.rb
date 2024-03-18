# frozen_string_literal: true

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

ActiveRecord::Schema[7.1].define(version: 20_240_318_094_020) do
  create_table "accounts", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string("name")
    t.string("email")
    t.integer("role")
    t.string("address")
    t.string("phone_number")
    t.string("password_digest")
    t.string("remember_digest")
    t.datetime("created_at", null: false)
    t.datetime("updated_at", null: false)
  end

  create_table "categories", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string("name")
    t.datetime("created_at", null: false)
    t.datetime("updated_at", null: false)
  end

  create_table "comments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer("account_id")
    t.integer("product_id")
    t.string("content")
    t.integer("parent_id")
    t.integer("rating")
    t.datetime("created_at", null: false)
    t.datetime("updated_at", null: false)
  end

  create_table "order_histories", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer("order_id")
    t.integer("product_id")
    t.integer("quantity")
    t.integer("current_price")
    t.datetime("created_at", null: false)
    t.datetime("updated_at", null: false)
  end

  create_table "orders", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer("account_id")
    t.integer("status")
    t.string("receiver_name")
    t.string("receiver_address")
    t.string("receiver_phone_number")
    t.datetime("created_at", null: false)
    t.datetime("updated_at", null: false)
  end

  create_table "products", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string("name")
    t.integer("price")
    t.string("description")
    t.integer("quantity")
    t.integer("category_id")
    t.datetime("created_at", null: false)
    t.datetime("updated_at", null: false)
  end
end
