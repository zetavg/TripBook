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

ActiveRecord::Schema.define(version: 20170219035433) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "book_holdings", force: :cascade do |t|
    t.integer  "user_id",                          null: false
    t.integer  "book_id",                          null: false
    t.integer  "previous_holding_id"
    t.string   "state",                 limit: 16, null: false
    t.datetime "ready_for_released_at"
    t.datetime "released_at"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.index ["book_id"], name: "index_book_holdings_on_book_id", using: :btree
    t.index ["previous_holding_id"], name: "index_book_holdings_on_previous_holding_id", using: :btree
    t.index ["state"], name: "index_book_holdings_on_state", using: :btree
    t.index ["user_id"], name: "index_book_holdings_on_user_id", using: :btree
  end

  create_table "book_infos", primary_key: "isbn", id: :string, limit: 32, force: :cascade do |t|
    t.string   "isbn_10",      limit: 32
    t.string   "isbn_13",      limit: 32
    t.string   "name",         limit: 128, null: false
    t.string   "cover_image"
    t.string   "language",     limit: 64
    t.string   "author",       limit: 64
    t.string   "publisher",    limit: 64
    t.date     "publish_date"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["isbn"], name: "index_book_infos_on_isbn", unique: true, using: :btree
    t.index ["isbn_10"], name: "index_book_infos_on_isbn_10", unique: true, using: :btree
    t.index ["isbn_13"], name: "index_book_infos_on_isbn_13", unique: true, using: :btree
  end

  create_table "books", force: :cascade do |t|
    t.string   "isbn"
    t.integer  "owner_id",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["isbn"], name: "index_books_on_isbn", using: :btree
    t.index ["owner_id"], name: "index_books_on_owner_id", using: :btree
  end

  create_table "user_cover_photos", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "image"
    t.string   "secure_token"
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["secure_token"], name: "index_user_cover_photos_on_secure_token", unique: true, using: :btree
    t.index ["user_id"], name: "index_user_cover_photos_on_user_id", using: :btree
  end

  create_table "user_facebook_accounts", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "facebook_id",             null: false
    t.string   "email"
    t.string   "name"
    t.text     "picture_url"
    t.text     "cover_photo_url"
    t.text     "access_token",            null: false
    t.integer  "access_token_expires_at", null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.index ["email"], name: "index_user_facebook_accounts_on_email", using: :btree
    t.index ["facebook_id"], name: "index_user_facebook_accounts_on_facebook_id", unique: true, using: :btree
    t.index ["user_id"], name: "index_user_facebook_accounts_on_user_id", using: :btree
  end

  create_table "user_pictures", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "image"
    t.string   "secure_token"
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["secure_token"], name: "index_user_pictures_on_secure_token", unique: true, using: :btree
    t.index ["user_id"], name: "index_user_pictures_on_user_id", using: :btree
  end

  create_table "user_profiles", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "gender",         limit: 2
    t.bigint   "birthday_year"
    t.integer  "birthday_month", limit: 2
    t.integer  "birthday_day",   limit: 2
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["user_id"], name: "index_user_profiles_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                                  default: "", null: false
    t.string   "mobile",                      limit: 32
    t.string   "encrypted_password",                     default: "", null: false
    t.string   "locale",                      limit: 8
    t.string   "username",                    limit: 64
    t.string   "name",                        limit: 64,              null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "mobile_confirmation_token"
    t.datetime "mobile_confirmed_at"
    t.datetime "mobile_confirmation_sent_at"
    t.string   "unconfirmed_mobile",          limit: 32
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["username"], name: "index_users_on_username", unique: true, using: :btree
  end

  add_foreign_key "book_holdings", "book_holdings", column: "previous_holding_id"
  add_foreign_key "book_holdings", "books"
  add_foreign_key "book_holdings", "users"
  add_foreign_key "books", "users", column: "owner_id"
  add_foreign_key "user_cover_photos", "users"
  add_foreign_key "user_facebook_accounts", "users"
  add_foreign_key "user_pictures", "users"
  add_foreign_key "user_profiles", "users"
end
