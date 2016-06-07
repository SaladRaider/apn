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

ActiveRecord::Schema.define(version: 20160607174133) do

  create_table "assigned_jobs", force: :cascade do |t|
    t.string   "job_descriptoin", limit: 255, default: "", null: false
    t.integer  "user_id",         limit: 4
    t.integer  "video_id",        limit: 4
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  create_table "contacts", force: :cascade do |t|
    t.string   "full_name",  limit: 255
    t.string   "email",      limit: 255
    t.string   "subject",    limit: 255
    t.text     "message",    limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "contents", force: :cascade do |t|
    t.text     "text",               limit: 65535, null: false
    t.string   "media_file_name",    limit: 255
    t.string   "media_content_type", limit: 255
    t.integer  "media_file_size",    limit: 4
    t.datetime "media_updated_at"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "title",              limit: 255
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",           limit: 255, null: false
    t.integer  "sluggable_id",   limit: 4,   null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope",          limit: 255
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "grading", force: :cascade do |t|
    t.string  "grader",        limit: 100
    t.string  "gs1",           limit: 20
    t.string  "gs2",           limit: 20
    t.string  "gs3",           limit: 20
    t.string  "gs4",           limit: 20
    t.string  "gs5",           limit: 20
    t.string  "gs6",           limit: 20
    t.string  "gs7",           limit: 20
    t.integer "submission_id", limit: 4
  end

  create_table "suggestions", force: :cascade do |t|
    t.string   "subject",    limit: 255
    t.text     "message",    limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name",             limit: 255
    t.string   "last_name",              limit: 255
    t.string   "username",               limit: 255
    t.integer  "id_number",              limit: 4
    t.integer  "grade",                  limit: 4
    t.integer  "admin_confirmed",        limit: 4,     default: 0,  null: false
    t.string   "email",                  limit: 255,   default: "", null: false
    t.string   "encrypted_password",     limit: 255,   default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,     default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.text     "bio",                    limit: 65535
    t.string   "role",                   limit: 255
    t.string   "slug",                   limit: 255
    t.string   "avatar_file_name",       limit: 255
    t.string   "avatar_content_type",    limit: 255
    t.integer  "avatar_file_size",       limit: 4
    t.datetime "avatar_updated_at"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["slug"], name: "index_users_on_slug", unique: true, using: :btree

  create_table "videos", force: :cascade do |t|
    t.string   "title",       limit: 255
    t.integer  "show",        limit: 4
    t.string   "link",        limit: 255
    t.text     "description", limit: 65535
    t.string   "keywords",    limit: 255
    t.integer  "category",    limit: 4
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "user_id",     limit: 4
    t.string   "slug",        limit: 255
    t.integer  "views",       limit: 4,     default: 0, null: false
  end

  add_index "videos", ["slug"], name: "index_videos_on_slug", unique: true, using: :btree

end
