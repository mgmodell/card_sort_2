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

ActiveRecord::Schema.define(version: 2018_05_11_164157) do

  create_table "authors", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "given_name"
    t.string "family_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "authors_sources", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "author_id", null: false
    t.bigint "source_id", null: false
    t.index ["source_id", "author_id"], name: "index_authors_sources_on_source_id_and_author_id", unique: true
  end

  create_table "datasets", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "load_pct"
    t.text "stats_cache"
    t.index ["user_id"], name: "index_datasets_on_user_id"
  end

  create_table "factors", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "source_id"
    t.text "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "unverified"
    t.index ["source_id"], name: "index_factors_on_source_id"
  end

  create_table "factors_words", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "word_id", null: false
    t.bigint "factor_id", null: false
    t.index ["factor_id", "word_id"], name: "index_factors_words_on_factor_id_and_word_id", unique: true
  end

  create_table "references", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "source_id"
    t.integer "reference_source_id"
    t.index ["reference_source_id", "source_id"], name: "index_references_on_reference_source_id_and_source_id", unique: true
    t.index ["source_id", "reference_source_id"], name: "index_references_on_source_id_and_reference_source_id", unique: true
  end

  create_table "sources", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "citation"
    t.string "author_list"
    t.integer "year"
    t.string "purpose"
    t.bigint "topic_id"
    t.string "discard_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "title"
    t.bigint "dataset_id"
    t.boolean "processed"
    t.boolean "refs_processed"
    t.text "word_cache"
    t.text "stem_cache"
    t.text "synonym_cache"
    t.text "stats_cache"
    t.boolean "discarded"
    t.index ["dataset_id"], name: "index_sources_on_dataset_id"
    t.index ["topic_id"], name: "index_sources_on_topic_id"
  end

  create_table "stems", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "word"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "synonyms", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "word"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "synonyms_words", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "word_id", null: false
    t.bigint "synonym_id", null: false
    t.index ["synonym_id", "word_id"], name: "index_synonyms_words_on_synonym_id_and_word_id", unique: true
  end

  create_table "topics", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "token"
    t.text "refresh_token"
    t.integer "expires_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "words", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "raw"
    t.bigint "stem_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "syn_checked", default: false, null: false
    t.string "tag"
    t.index ["stem_id"], name: "index_words_on_stem_id"
  end

  add_foreign_key "datasets", "users"
  add_foreign_key "factors", "sources"
  add_foreign_key "sources", "datasets"
  add_foreign_key "words", "stems"
end
