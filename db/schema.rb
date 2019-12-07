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

ActiveRecord::Schema.define(version: 2019_12_07_014259) do

  create_table "cart_details", force: :cascade do |t|
    t.integer "product_id"
    t.integer "cart_id"
    t.integer "qty"
    t.decimal "actual_price"
    t.decimal "discounted_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cart_id"], name: "index_cart_details_on_cart_id"
    t.index ["product_id"], name: "index_cart_details_on_product_id"
  end

  create_table "carts", force: :cascade do |t|
    t.integer "user_id"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "discount_rules", force: :cascade do |t|
    t.integer "product_id"
    t.boolean "active"
    t.integer "qty"
    t.integer "discount_price"
    t.integer "discount_percentage"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_discount_rules_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.decimal "price"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "total_discount_rules", force: :cascade do |t|
    t.integer "total"
    t.integer "additional_discount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
