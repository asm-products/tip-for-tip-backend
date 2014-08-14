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

ActiveRecord::Schema.define(version: 20140730055146) do

  create_table "cash_accounts", force: true do |t|
    t.integer  "user_id"
    t.integer  "balance_cents", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cash_entries", force: true do |t|
    t.integer  "cash_account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "iap_receipt_verifications", force: true do |t|
    t.integer  "user_id"
    t.boolean  "successful"
    t.string   "transaction_id"
    t.string   "result"
    t.string   "result_message"
    t.string   "service"
    t.text     "encoded_receipt_data"
    t.text     "receipt_data"
    t.text     "request_metadata"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "iap_receipt_verifications", ["result"], name: "index_iap_receipt_verifications_on_result", using: :btree
  add_index "iap_receipt_verifications", ["result_message"], name: "index_iap_receipt_verifications_on_result_message", using: :btree
  add_index "iap_receipt_verifications", ["successful"], name: "index_iap_receipt_verifications_on_successful", using: :btree
  add_index "iap_receipt_verifications", ["transaction_id"], name: "index_iap_receipt_verifications_on_transaction_id", using: :btree
  add_index "iap_receipt_verifications", ["user_id"], name: "index_iap_receipt_verifications_on_user_id", using: :btree

  create_table "identities", force: true do |t|
    t.integer  "user_id"
    t.string   "uid"
    t.string   "provider"
    t.string   "token"
    t.datetime "token_expires_at"
    t.text     "profile_data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "identities", ["provider"], name: "index_identities_on_provider", using: :btree
  add_index "identities", ["user_id"], name: "index_identities_on_user_id", using: :btree

  create_table "noun_creators", force: true do |t|
    t.integer  "user_id"
    t.integer  "noun_id"
    t.string   "noun_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "noun_creators", ["noun_type", "noun_id"], name: "index_noun_creators_on_noun_type_and_noun_id", using: :btree
  add_index "noun_creators", ["user_id"], name: "index_noun_creators_on_user_id", using: :btree

  create_table "nouns_persons", force: true do |t|
    t.string   "uuid",       limit: 36, null: false
    t.string   "name",                  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "nouns_persons", ["name"], name: "index_nouns_persons_on_name", using: :btree
  add_index "nouns_persons", ["uuid"], name: "index_nouns_persons_on_uuid", unique: true, using: :btree

  create_table "nouns_places", force: true do |t|
    t.string   "uuid",            limit: 36, null: false
    t.string   "name",                       null: false
    t.float    "latitude"
    t.float    "longitude"
    t.text     "foursquare_data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "foursquare_id"
  end

  add_index "nouns_places", ["foursquare_id"], name: "index_nouns_places_on_foursquare_id", using: :btree
  add_index "nouns_places", ["latitude"], name: "index_nouns_places_on_latitude", using: :btree
  add_index "nouns_places", ["longitude"], name: "index_nouns_places_on_longitude", using: :btree
  add_index "nouns_places", ["name"], name: "index_nouns_places_on_name", using: :btree
  add_index "nouns_places", ["uuid"], name: "index_nouns_places_on_uuid", unique: true, using: :btree

  create_table "nouns_things", force: true do |t|
    t.string   "uuid",       limit: 36, null: false
    t.string   "name",                  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "nouns_things", ["name"], name: "index_nouns_things_on_name", using: :btree
  add_index "nouns_things", ["uuid"], name: "index_nouns_things_on_uuid", unique: true, using: :btree

  create_table "partners", force: true do |t|
    t.integer  "primary_user_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "partners", ["primary_user_id"], name: "index_partners_on_primary_user_id", using: :btree

  create_table "perks", force: true do |t|
    t.integer  "subscription_id",            null: false
    t.string   "title",                      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uuid",            limit: 36, null: false
  end

  add_index "perks", ["subscription_id"], name: "index_perks_on_subscription_id", using: :btree
  add_index "perks", ["uuid"], name: "index_perks_on_uuid", using: :btree

  create_table "plutus_accounts", force: true do |t|
    t.string   "name"
    t.string   "type"
    t.boolean  "contra"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "plutus_accounts", ["id"], name: "index_plutus_accounts_on_id", using: :btree
  add_index "plutus_accounts", ["name", "type"], name: "index_plutus_accounts_on_name_and_type", using: :btree

  create_table "plutus_amounts", force: true do |t|
    t.string  "type"
    t.integer "account_id"
    t.integer "entry_id"
    t.decimal "amount",     precision: 20, scale: 10
  end

  add_index "plutus_amounts", ["account_id", "entry_id"], name: "index_plutus_amounts_on_account_id_and_entry_id", using: :btree
  add_index "plutus_amounts", ["entry_id", "account_id"], name: "index_plutus_amounts_on_entry_id_and_account_id", using: :btree
  add_index "plutus_amounts", ["type"], name: "index_plutus_amounts_on_type", using: :btree

  create_table "plutus_entries", force: true do |t|
    t.string   "description"
    t.string   "type"
    t.integer  "commercial_document_id"
    t.string   "commercial_document_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "plutus_entries", ["commercial_document_id", "commercial_document_type"], name: "index_entries_on_commercial_doc", using: :btree

  create_table "purchases", force: true do |t|
    t.string   "service"
    t.string   "transaction_id"
    t.datetime "transaction_timestamp"
    t.integer  "tip_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "iap_receipt_verification_id"
    t.integer  "purchase_entry_id"
  end

  add_index "purchases", ["purchase_entry_id"], name: "index_purchases_on_purchase_entry_id", using: :btree
  add_index "purchases", ["service"], name: "index_purchases_on_service", using: :btree
  add_index "purchases", ["tip_id"], name: "index_purchases_on_tip_id", using: :btree
  add_index "purchases", ["transaction_id"], name: "index_purchases_on_transaction_id", using: :btree
  add_index "purchases", ["user_id"], name: "index_purchases_on_user_id", using: :btree

  create_table "subscriptions", force: true do |t|
    t.integer  "partner_id", null: false
    t.integer  "noun_id",    null: false
    t.string   "noun_type",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subscriptions", ["noun_id", "noun_type"], name: "index_subscriptions_on_noun_id_and_noun_type", using: :btree
  add_index "subscriptions", ["partner_id"], name: "index_subscriptions_on_partner_id", using: :btree

  create_table "tips", force: true do |t|
    t.string   "uuid",          limit: 36,                 null: false
    t.string   "subject",                                  null: false
    t.text     "body",                                     null: false
    t.integer  "user_id"
    t.integer  "noun_id"
    t.string   "noun_type"
    t.boolean  "is_free",                  default: false
    t.boolean  "sent",                     default: false
    t.datetime "send_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "display_as"
    t.boolean  "is_compliment",            default: false
  end

  add_index "tips", ["noun_id", "noun_type"], name: "index_tips_on_noun_id_and_noun_type", using: :btree
  add_index "tips", ["sent"], name: "index_tips_on_sent", using: :btree
  add_index "tips", ["user_id"], name: "index_tips_on_user_id", using: :btree
  add_index "tips", ["uuid"], name: "index_tips_on_uuid", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "uuid",                limit: 36,             null: false
    t.string   "username",                                   null: false
    t.string   "email",                                      null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "timezone"
    t.string   "locale"
    t.datetime "last_request_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                  default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "partner_id"
    t.integer  "customer_account_id"
  end

  add_index "users", ["customer_account_id"], name: "index_users_on_customer_account_id", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["partner_id"], name: "index_users_on_partner_id", using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree
  add_index "users", ["uuid"], name: "index_users_on_uuid", unique: true, using: :btree

end
