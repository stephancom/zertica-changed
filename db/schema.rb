# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140120220045) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_chats", force: true do |t|
    t.integer  "user_id",    null: false
    t.integer  "admin_id",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_chats", ["admin_id"], name: "index_active_chats_on_admin_id", using: :btree
  add_index "active_chats", ["user_id", "admin_id"], name: "index_active_chats_on_user_id_and_admin_id", unique: true, using: :btree
  add_index "active_chats", ["user_id"], name: "index_active_chats_on_user_id", using: :btree

  create_table "admins", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "customer_uri"
    t.string   "bank_account_uri"
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree
  add_index "admins", ["unlock_token"], name: "index_admins_on_unlock_token", unique: true, using: :btree

  create_table "authors", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bids", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "admin_id"
    t.integer  "order_id"
    t.decimal  "price"
    t.boolean  "selected",                                default: false
    t.text     "message"
    t.string   "pay_schedule"
    t.decimal  "subtotal",        precision: 8, scale: 2
    t.integer  "estimated_hours"
  end

  create_table "file_objects", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "admin_id"
    t.integer  "order_id"
    t.string   "url",            null: false
    t.string   "filename",       null: false
    t.integer  "size",           null: false
    t.string   "mimetype",       null: false
    t.integer  "product_id"
    t.string   "sendshapes_url"
  end

  create_table "messages", force: true do |t|
    t.text     "body",         null: false
    t.integer  "user_id",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "admin_id"
    t.integer  "speaker_id"
    t.string   "speaker_type"
  end

  add_index "messages", ["admin_id"], name: "index_messages_on_admin_id", using: :btree
  add_index "messages", ["speaker_id", "speaker_type"], name: "index_messages_on_speaker_id_and_speaker_type", using: :btree
  add_index "messages", ["user_id"], name: "index_messages_on_user_id", using: :btree

  create_table "orders", force: true do |t|
    t.string   "order_type"
    t.string   "state",                                    default: "submitted", null: false
    t.string   "title",                                                          null: false
    t.text     "description"
    t.decimal  "price",            precision: 8, scale: 2
    t.string   "carrier"
    t.string   "tracking_number"
    t.string   "confirmation"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "admin_id"
    t.string   "deadline"
    t.string   "color"
    t.string   "material"
    t.string   "budget"
    t.integer  "quantity"
    t.string   "software_program"
    t.string   "file_format"
    t.decimal  "subtotal",         precision: 8, scale: 2
    t.string   "debit_uri"
    t.string   "credit_uri"
    t.string   "city"
    t.string   "province"
  end

  create_table "orders_file_objects", id: false, force: true do |t|
    t.integer "order_id"
    t.integer "file_object_id"
  end

  add_index "orders_file_objects", ["file_object_id"], name: "index_orders_file_objects_on_file_object_id", using: :btree
  add_index "orders_file_objects", ["order_id", "file_object_id"], name: "index_orders_file_objects_on_order_id_and_file_object_id", using: :btree
  add_index "orders_file_objects", ["order_id"], name: "index_orders_file_objects_on_order_id", using: :btree

  create_table "orders_files", id: false, force: true do |t|
    t.integer "order_id"
    t.integer "file_object_id"
  end

  create_table "orders_shippable_files", id: false, force: true do |t|
    t.integer "order_id"
    t.integer "file_object_id"
  end

  add_index "orders_shippable_files", ["file_object_id"], name: "index_orders_shippable_files_on_file_object_id", using: :btree
  add_index "orders_shippable_files", ["order_id", "file_object_id"], name: "index_orders_shippable_files_on_order_id_and_file_object_id", unique: true, using: :btree
  add_index "orders_shippable_files", ["order_id"], name: "index_orders_shippable_files_on_order_id", using: :btree

  create_table "products", force: true do |t|
    t.integer  "admin_id"
    t.string   "title"
    t.text     "description"
    t.decimal  "price",       precision: 8, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products_file_objects", id: false, force: true do |t|
    t.integer "product_id"
    t.integer "file_object_id"
  end

  add_index "products_file_objects", ["file_object_id"], name: "index_products_file_objects_on_file_object_id", using: :btree
  add_index "products_file_objects", ["product_id", "file_object_id"], name: "index_products_file_objects_on_product_id_and_file_object_id", using: :btree
  add_index "products_file_objects", ["product_id"], name: "index_products_file_objects_on_product_id", using: :btree

  create_table "products_files", id: false, force: true do |t|
    t.integer "product_id"
    t.integer "file_object_id"
  end

  create_table "reviews", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "storefront_id"
    t.integer  "user_id"
    t.string   "title"
    t.text     "description"
    t.integer  "rating"
  end

  create_table "storefronts", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "vendor_name"
    t.integer  "admin_id"
    t.text     "description"
    t.boolean  "ships"
    t.boolean  "pickup"
    t.string   "city"
    t.string   "state"
    t.boolean  "cad"
    t.boolean  "print"
    t.boolean  "hub"
    t.text     "image1"
    t.text     "image2"
    t.text     "image3"
    t.text     "image4"
  end

  create_table "users", force: true do |t|
    t.string   "email",                    default: "",    null: false
    t.string   "encrypted_password",       default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",            default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.boolean  "email_messages",           default: false, null: false
    t.boolean  "email_estimate",           default: true,  null: false
    t.boolean  "email_complete",           default: true,  null: false
    t.boolean  "email_shipped",            default: true,  null: false
    t.string   "provider"
    t.string   "uid"
    t.integer  "last_notified_message_id"
    t.datetime "last_saw_messages_at"
    t.string   "customer_uri"
    t.string   "card_uri"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
