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

ActiveRecord::Schema.define(version: 20140519092442) do

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
  end

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
    t.integer  "subscription_id", null: false
    t.string   "title",           null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "perks", ["subscription_id"], name: "index_perks_on_subscription_id", using: :btree

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
    t.string   "uuid",                         limit: 36, null: false
    t.string   "subject",                                 null: false
    t.text     "body",                                    null: false
    t.integer  "user_id"
    t.integer  "noun_id"
    t.string   "noun_type"
    t.boolean  "is_annonymous"
    t.boolean  "can_purchase_with_reputation"
    t.boolean  "sent"
    t.datetime "send_at"
    t.datetime "created_at"
    t.datetime "updated_at"
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
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["partner_id"], name: "index_users_on_partner_id", using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree
  add_index "users", ["uuid"], name: "index_users_on_uuid", unique: true, using: :btree

end
