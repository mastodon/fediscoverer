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

ActiveRecord::Schema[8.0].define(version: 2025_06_13_134946) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pg_trgm"

  create_table "actor_languages", force: :cascade do |t|
    t.bigint "actor_id", null: false
    t.string "language", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["actor_id", "language"], name: "index_actor_languages_on_actor_id_and_language", unique: true
    t.index ["actor_id"], name: "index_actor_languages_on_actor_id"
  end

  create_table "actors", force: :cascade do |t|
    t.bigint "server_id", null: false
    t.string "uri", null: false
    t.string "actor_type", default: "Person", null: false
    t.boolean "discoverable", default: false, null: false
    t.boolean "indexable", default: false, null: false
    t.text "full_text"
    t.regconfig "pg_text_search_configuration", default: "english", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "followers_count", default: 0, null: false
    t.boolean "recommended", default: false, null: false
    t.index "to_tsvector(pg_text_search_configuration, full_text)", name: "actors_description_idx", using: :gin
    t.index ["server_id"], name: "index_actors_on_server_id"
    t.index ["uri"], name: "index_actors_on_uri", unique: true
  end

  create_table "content_activities", force: :cascade do |t|
    t.bigint "content_object_id", null: false
    t.datetime "hour_of_activity", null: false
    t.integer "shares", default: 0, null: false
    t.integer "likes", default: 0, null: false
    t.integer "replies", default: 0, null: false
    t.float "score", default: 0.0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "trend_signals", default: 0, null: false
    t.index ["content_object_id", "hour_of_activity"], name: "idx_on_content_object_id_hour_of_activity_6ed57d161f", unique: true
    t.index ["content_object_id"], name: "index_content_activities_on_content_object_id"
  end

  create_table "content_objects", force: :cascade do |t|
    t.bigint "actor_id", null: false
    t.string "uri", null: false
    t.string "object_type", null: false
    t.datetime "published_at", null: false
    t.datetime "last_edited_at", null: false
    t.boolean "sensitive", null: false
    t.string "language"
    t.integer "attached_images", default: 0, null: false
    t.integer "attached_videos", default: 0, null: false
    t.integer "attached_audio", default: 0, null: false
    t.integer "replies", default: 0, null: false
    t.integer "likes", default: 0, null: false
    t.integer "shares", default: 0, null: false
    t.text "full_text"
    t.regconfig "pg_text_search_configuration", default: "english", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "trend_signals", default: 0, null: false
    t.index "to_tsvector(pg_text_search_configuration, full_text)", name: "content_objects_full_text_idx", using: :gin
    t.index ["actor_id"], name: "index_content_objects_on_actor_id"
    t.index ["uri"], name: "index_content_objects_on_uri", unique: true
  end

  create_table "fasp_base_admin_users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_fasp_base_admin_users_on_email", unique: true
  end

  create_table "fasp_base_invitation_codes", force: :cascade do |t|
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_fasp_base_invitation_codes_on_code", unique: true
  end

  create_table "fasp_base_servers", force: :cascade do |t|
    t.string "base_url", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "fasp_private_key_pem", null: false
    t.string "fasp_remote_id"
    t.string "public_key_pem"
    t.string "registration_completion_uri"
    t.json "enabled_capabilities"
    t.index ["base_url"], name: "index_fasp_base_servers_on_base_url", unique: true
    t.index ["user_id"], name: "index_fasp_base_servers_on_user_id"
  end

  create_table "fasp_base_settings", force: :cascade do |t|
    t.string "name", null: false
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_fasp_base_settings_on_name", unique: true
  end

  create_table "fasp_base_users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true, null: false
    t.index ["email"], name: "index_fasp_base_users_on_email", unique: true
  end

  create_table "fasp_data_sharing_actors", force: :cascade do |t|
    t.text "private_key_pem", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fasp_data_sharing_backfill_requests", force: :cascade do |t|
    t.bigint "fasp_base_server_id", null: false
    t.string "remote_id", null: false
    t.string "category", null: false
    t.integer "max_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "fulfilled", default: false, null: false
    t.index ["fasp_base_server_id"], name: "idx_on_fasp_base_server_id_0f3fe7f51e"
  end

  create_table "fasp_data_sharing_subscriptions", force: :cascade do |t|
    t.bigint "fasp_base_server_id", null: false
    t.string "remote_id", null: false
    t.string "category", null: false
    t.string "subscription_type", null: false
    t.integer "max_batch_size"
    t.integer "threshold_timeframe"
    t.integer "threshold_shares"
    t.integer "threshold_likes"
    t.integer "threshold_replies"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["fasp_base_server_id"], name: "index_fasp_data_sharing_subscriptions_on_fasp_base_server_id"
  end

  create_table "hashtag_activities", force: :cascade do |t|
    t.bigint "hashtag_id", null: false
    t.datetime "hour_of_activity", null: false
    t.integer "total_uses", default: 0, null: false
    t.integer "distinct_users", default: 0, null: false
    t.integer "shares", default: 0, null: false
    t.integer "likes", default: 0, null: false
    t.integer "replies", default: 0, null: false
    t.float "score", default: 0.0, null: false
    t.string "language"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "trend_signals", default: 0, null: false
    t.index ["hashtag_id", "hour_of_activity", "language"], name: "idx_on_hashtag_id_hour_of_activity_language_65749e4bf4", unique: true
    t.index ["hashtag_id"], name: "index_hashtag_activities_on_hashtag_id"
  end

  create_table "hashtag_usages", force: :cascade do |t|
    t.bigint "content_object_id", null: false
    t.bigint "hashtag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["content_object_id", "hashtag_id"], name: "index_hashtag_usages_on_content_object_id_and_hashtag_id", unique: true
    t.index ["content_object_id"], name: "index_hashtag_usages_on_content_object_id"
    t.index ["hashtag_id"], name: "index_hashtag_usages_on_hashtag_id"
  end

  create_table "hashtags", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_hashtags_on_name", unique: true
  end

  create_table "link_activities", force: :cascade do |t|
    t.bigint "link_id", null: false
    t.datetime "hour_of_activity", null: false
    t.integer "total_uses", default: 0, null: false
    t.integer "distinct_users", default: 0, null: false
    t.integer "shares", default: 0, null: false
    t.integer "likes", default: 0, null: false
    t.integer "replies", default: 0, null: false
    t.float "score", default: 0.0, null: false
    t.string "language"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "trend_signals", default: 0, null: false
    t.index ["link_id", "hour_of_activity", "language"], name: "idx_on_link_id_hour_of_activity_language_ca2e4ae168", unique: true
    t.index ["link_id"], name: "index_link_activities_on_link_id"
  end

  create_table "link_usages", force: :cascade do |t|
    t.bigint "content_object_id", null: false
    t.bigint "link_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["content_object_id", "link_id"], name: "index_link_usages_on_content_object_id_and_link_id", unique: true
    t.index ["content_object_id"], name: "index_link_usages_on_content_object_id"
    t.index ["link_id"], name: "index_link_usages_on_link_id"
  end

  create_table "links", force: :cascade do |t|
    t.string "url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["url"], name: "index_links_on_url", unique: true
  end

  create_table "servers", force: :cascade do |t|
    t.string "domain_name", null: false
    t.boolean "available", default: true, null: false
    t.datetime "last_queried_at"
    t.integer "connection_failures", default: 0, null: false
    t.datetime "pause_until"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "blocked", default: false, null: false
    t.index ["domain_name"], name: "index_servers_on_domain_name", unique: true
  end

  add_foreign_key "actor_languages", "actors"
  add_foreign_key "actors", "servers"
  add_foreign_key "content_activities", "content_objects"
  add_foreign_key "content_objects", "actors"
  add_foreign_key "fasp_base_servers", "fasp_base_users", column: "user_id"
  add_foreign_key "fasp_data_sharing_backfill_requests", "fasp_base_servers"
  add_foreign_key "fasp_data_sharing_subscriptions", "fasp_base_servers"
  add_foreign_key "hashtag_activities", "hashtags"
  add_foreign_key "hashtag_usages", "content_objects"
  add_foreign_key "hashtag_usages", "hashtags"
  add_foreign_key "link_activities", "links"
  add_foreign_key "link_usages", "content_objects"
  add_foreign_key "link_usages", "links"
end
