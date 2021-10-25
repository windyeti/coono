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

ActiveRecord::Schema.define(version: 20211025160332) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "category_contacts", force: :cascade do |t|
    t.integer  "boss_id"
    t.string   "name"
    t.string   "link"
    t.string   "category_path"
    t.boolean  "parsing",       default: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["boss_id"], name: "index_category_contacts_on_boss_id", using: :btree
  end

  create_table "category_dantexgroups", force: :cascade do |t|
    t.integer  "boss_id"
    t.string   "name"
    t.string   "link"
    t.string   "category_path"
    t.boolean  "parsing",       default: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["boss_id"], name: "index_category_dantexgroups_on_boss_id", using: :btree
  end

  create_table "category_dims", force: :cascade do |t|
    t.integer  "boss_id"
    t.string   "name"
    t.string   "link"
    t.string   "category_path"
    t.boolean  "parsing",       default: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["boss_id"], name: "index_category_dims_on_boss_id", using: :btree
  end

  create_table "category_kovchegs", force: :cascade do |t|
    t.integer  "boss_id"
    t.string   "name"
    t.string   "link"
    t.string   "category_path"
    t.boolean  "parsing",       default: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["boss_id"], name: "index_category_kovchegs_on_boss_id", using: :btree
  end

  create_table "category_lit_koms", force: :cascade do |t|
    t.integer  "boss_id"
    t.string   "name"
    t.string   "link"
    t.string   "category_path"
    t.boolean  "parsing",       default: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["boss_id"], name: "index_category_lit_koms_on_boss_id", using: :btree
  end

  create_table "category_nkamins", force: :cascade do |t|
    t.integer  "boss_id"
    t.string   "name"
    t.string   "link"
    t.string   "category_path"
    t.boolean  "parsing",       default: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["boss_id"], name: "index_category_nkamins_on_boss_id", using: :btree
  end

  create_table "category_realflames", force: :cascade do |t|
    t.integer  "boss_id"
    t.string   "name"
    t.string   "link"
    t.string   "category_path"
    t.boolean  "parsing",       default: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["boss_id"], name: "index_category_realflames_on_boss_id", using: :btree
  end

  create_table "category_saunarus", force: :cascade do |t|
    t.integer  "boss_id"
    t.string   "name"
    t.string   "link"
    t.string   "category_path"
    t.boolean  "parsing",       default: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["boss_id"], name: "index_category_saunarus_on_boss_id", using: :btree
  end

  create_table "category_sawos", force: :cascade do |t|
    t.integer  "boss_id"
    t.string   "name"
    t.string   "link"
    t.string   "category_path"
    t.boolean  "parsing",       default: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["boss_id"], name: "index_category_sawos_on_boss_id", using: :btree
  end

  create_table "category_shulepovs", force: :cascade do |t|
    t.integer  "boss_id"
    t.string   "name"
    t.string   "link"
    t.string   "category_path"
    t.boolean  "parsing",       default: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["boss_id"], name: "index_category_shulepovs_on_boss_id", using: :btree
  end

  create_table "category_teplodars", force: :cascade do |t|
    t.integer  "boss_id"
    t.string   "name"
    t.string   "link"
    t.string   "category_path"
    t.boolean  "parsing",       default: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["boss_id"], name: "index_category_teplodars_on_boss_id", using: :btree
  end

  create_table "category_teplomarkets", force: :cascade do |t|
    t.integer  "boss_id"
    t.string   "name"
    t.string   "link"
    t.string   "category_path"
    t.boolean  "parsing",       default: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["boss_id"], name: "index_category_teplomarkets_on_boss_id", using: :btree
  end

  create_table "category_tmfs", force: :cascade do |t|
    t.integer  "boss_id"
    t.string   "name"
    t.string   "link"
    t.string   "category_path"
    t.boolean  "parsing",       default: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["boss_id"], name: "index_category_tmfs_on_boss_id", using: :btree
  end

  create_table "category_wellfits", force: :cascade do |t|
    t.integer  "boss_id"
    t.string   "name"
    t.string   "link"
    t.string   "category_path"
    t.boolean  "parsing",       default: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["boss_id"], name: "index_category_wellfits_on_boss_id", using: :btree
  end

  create_table "contacts", force: :cascade do |t|
    t.string   "fid"
    t.string   "link"
    t.string   "sku"
    t.string   "title"
    t.string   "sdesc"
    t.string   "desc"
    t.string   "oldprice"
    t.string   "price"
    t.string   "pict"
    t.string   "quantity"
    t.string   "cat"
    t.string   "cat1"
    t.string   "cat2"
    t.string   "cat3"
    t.string   "cat4"
    t.string   "mtitle"
    t.string   "mdesc"
    t.string   "mkeyw"
    t.string   "p1"
    t.string   "p2"
    t.string   "p3"
    t.string   "p4"
    t.string   "option1"
    t.string   "option2"
    t.string   "option3"
    t.string   "option4"
    t.string   "option5"
    t.string   "option6"
    t.string   "option7"
    t.string   "option8"
    t.string   "option9"
    t.string   "option10"
    t.string   "option11"
    t.string   "option12"
    t.string   "option13"
    t.string   "option14"
    t.boolean  "check",      default: true
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "dantexgroups", force: :cascade do |t|
    t.string   "fid"
    t.string   "link"
    t.string   "sku"
    t.string   "title"
    t.string   "sdesc"
    t.string   "desc"
    t.string   "oldprice"
    t.string   "price"
    t.string   "pict"
    t.string   "quantity"
    t.string   "cat"
    t.string   "cat1"
    t.string   "cat2"
    t.string   "cat3"
    t.string   "cat4"
    t.string   "mtitle"
    t.string   "mdesc"
    t.string   "mkeyw"
    t.string   "p1"
    t.string   "p2"
    t.string   "p3"
    t.string   "p4"
    t.string   "option1"
    t.string   "option2"
    t.string   "option3"
    t.string   "option4"
    t.string   "option5"
    t.string   "option6"
    t.string   "option7"
    t.string   "option8"
    t.string   "option9"
    t.string   "option10"
    t.string   "option11"
    t.string   "option12"
    t.string   "option13"
    t.string   "option14"
    t.boolean  "check",      default: true
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree
  end

  create_table "dims", force: :cascade do |t|
    t.string   "fid"
    t.string   "link"
    t.string   "sku"
    t.string   "title"
    t.string   "sdesc"
    t.string   "desc"
    t.string   "oldprice"
    t.float    "price"
    t.string   "pict"
    t.string   "quantity"
    t.string   "cat"
    t.string   "cat1"
    t.string   "cat2"
    t.string   "cat3"
    t.string   "cat4"
    t.string   "mtitle"
    t.string   "mdesc"
    t.string   "mkeyw"
    t.string   "p1"
    t.string   "p2"
    t.string   "p3"
    t.string   "p4"
    t.string   "option1"
    t.string   "option2"
    t.string   "option3"
    t.string   "option4"
    t.string   "option5"
    t.string   "option6"
    t.string   "option7"
    t.string   "option8"
    t.string   "option9"
    t.string   "option10"
    t.string   "option11"
    t.string   "option12"
    t.string   "option13"
    t.string   "option14"
    t.boolean  "check",      default: true
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "kovchegs", force: :cascade do |t|
    t.string   "fid"
    t.string   "link"
    t.string   "sku"
    t.string   "title"
    t.string   "sdesc"
    t.string   "desc"
    t.string   "oldprice"
    t.float    "price"
    t.string   "pict"
    t.string   "quantity"
    t.string   "cat"
    t.string   "cat1"
    t.string   "cat2"
    t.string   "cat3"
    t.string   "cat4"
    t.string   "mtitle"
    t.string   "mdesc"
    t.string   "mkeyw"
    t.string   "p1"
    t.string   "p2"
    t.string   "p3"
    t.string   "p4"
    t.string   "option1"
    t.string   "option2"
    t.string   "option3"
    t.string   "option4"
    t.string   "option5"
    t.string   "option6"
    t.string   "option7"
    t.string   "option8"
    t.string   "option9"
    t.string   "option10"
    t.string   "option11"
    t.string   "option12"
    t.string   "option13"
    t.string   "option14"
    t.boolean  "check",      default: true
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "lit_koms", force: :cascade do |t|
    t.string   "fid"
    t.string   "link"
    t.string   "sku"
    t.string   "title"
    t.string   "sdesc"
    t.string   "desc"
    t.string   "oldprice"
    t.float    "price"
    t.string   "pict"
    t.string   "quantity"
    t.string   "cat"
    t.string   "cat1"
    t.string   "cat2"
    t.string   "cat3"
    t.string   "cat4"
    t.string   "mtitle"
    t.string   "mdesc"
    t.string   "mkeyw"
    t.string   "p1"
    t.string   "p2"
    t.string   "p3"
    t.string   "p4"
    t.string   "option1"
    t.string   "option2"
    t.string   "option3"
    t.string   "option4"
    t.string   "option5"
    t.string   "option6"
    t.string   "option7"
    t.string   "option8"
    t.string   "option9"
    t.string   "option10"
    t.string   "option11"
    t.string   "option12"
    t.string   "option13"
    t.string   "option14"
    t.boolean  "check",      default: true
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "nkamins", force: :cascade do |t|
    t.string   "fid"
    t.string   "link"
    t.string   "sku"
    t.string   "title"
    t.string   "sdesc"
    t.string   "desc"
    t.string   "oldprice"
    t.float    "price"
    t.string   "pict"
    t.string   "quantity"
    t.string   "cat"
    t.string   "cat1"
    t.string   "cat2"
    t.string   "cat3"
    t.string   "cat4"
    t.string   "mtitle"
    t.string   "mdesc"
    t.string   "mkeyw"
    t.string   "p1"
    t.string   "p2"
    t.string   "p3"
    t.string   "p4"
    t.string   "option1"
    t.string   "option2"
    t.string   "option3"
    t.string   "option4"
    t.string   "option5"
    t.string   "option6"
    t.string   "option7"
    t.string   "option8"
    t.string   "option9"
    t.string   "option10"
    t.string   "option11"
    t.string   "option12"
    t.string   "option13"
    t.string   "option14"
    t.boolean  "check",      default: true
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "products", force: :cascade do |t|
    t.string   "sku"
    t.string   "title"
    t.string   "desc"
    t.string   "cat"
    t.decimal  "oldprice"
    t.decimal  "price"
    t.integer  "quantity"
    t.string   "image"
    t.string   "url"
    t.bigint   "insales_id"
    t.bigint   "insales_var_id"
    t.string   "distributor"
    t.string   "p1"
    t.boolean  "check",          default: true
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "lit_kom_id"
    t.integer  "kovcheg_id"
    t.integer  "nkamin_id"
    t.integer  "tmf_id"
    t.integer  "shulepov_id"
    t.integer  "realflame_id"
    t.integer  "dim_id"
    t.integer  "sawo_id"
    t.integer  "saunaru_id"
    t.integer  "teplodar_id"
    t.integer  "contact_id"
    t.integer  "teplomarket_id"
    t.integer  "dantexgroup_id"
    t.integer  "wellfit_id"
    t.index ["contact_id"], name: "index_products_on_contact_id", using: :btree
    t.index ["dantexgroup_id"], name: "index_products_on_dantexgroup_id", using: :btree
    t.index ["dim_id"], name: "index_products_on_dim_id", using: :btree
    t.index ["kovcheg_id"], name: "index_products_on_kovcheg_id", using: :btree
    t.index ["lit_kom_id"], name: "index_products_on_lit_kom_id", using: :btree
    t.index ["nkamin_id"], name: "index_products_on_nkamin_id", using: :btree
    t.index ["realflame_id"], name: "index_products_on_realflame_id", using: :btree
    t.index ["saunaru_id"], name: "index_products_on_saunaru_id", using: :btree
    t.index ["sawo_id"], name: "index_products_on_sawo_id", using: :btree
    t.index ["shulepov_id"], name: "index_products_on_shulepov_id", using: :btree
    t.index ["teplodar_id"], name: "index_products_on_teplodar_id", using: :btree
    t.index ["teplomarket_id"], name: "index_products_on_teplomarket_id", using: :btree
    t.index ["tmf_id"], name: "index_products_on_tmf_id", using: :btree
    t.index ["wellfit_id"], name: "index_products_on_wellfit_id", using: :btree
  end

  create_table "realflames", force: :cascade do |t|
    t.string   "fid"
    t.string   "link"
    t.string   "sku"
    t.string   "title"
    t.string   "sdesc"
    t.string   "desc"
    t.string   "oldprice"
    t.float    "price"
    t.string   "pict"
    t.string   "quantity"
    t.string   "cat"
    t.string   "cat1"
    t.string   "cat2"
    t.string   "cat3"
    t.string   "cat4"
    t.string   "mtitle"
    t.string   "mdesc"
    t.string   "mkeyw"
    t.string   "p1"
    t.string   "p2"
    t.string   "p3"
    t.string   "p4"
    t.string   "option1"
    t.string   "option2"
    t.string   "option3"
    t.string   "option4"
    t.string   "option5"
    t.string   "option6"
    t.string   "option7"
    t.string   "option8"
    t.string   "option9"
    t.string   "option10"
    t.string   "option11"
    t.string   "option12"
    t.string   "option13"
    t.string   "option14"
    t.boolean  "check",      default: true
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "saunarus", force: :cascade do |t|
    t.string   "fid"
    t.string   "link"
    t.string   "sku"
    t.string   "title"
    t.string   "sdesc"
    t.string   "desc"
    t.string   "oldprice"
    t.float    "price"
    t.string   "pict"
    t.string   "quantity"
    t.string   "cat"
    t.string   "cat1"
    t.string   "cat2"
    t.string   "cat3"
    t.string   "cat4"
    t.string   "mtitle"
    t.string   "mdesc"
    t.string   "mkeyw"
    t.string   "p1"
    t.string   "p2"
    t.string   "p3"
    t.string   "p4"
    t.string   "option1"
    t.string   "option2"
    t.string   "option3"
    t.string   "option4"
    t.string   "option5"
    t.string   "option6"
    t.string   "option7"
    t.string   "option8"
    t.string   "option9"
    t.string   "option10"
    t.string   "option11"
    t.string   "option12"
    t.string   "option13"
    t.string   "option14"
    t.boolean  "check",      default: true
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "sawos", force: :cascade do |t|
    t.string   "fid"
    t.string   "link"
    t.string   "sku"
    t.string   "title"
    t.string   "sdesc"
    t.string   "desc"
    t.string   "oldprice"
    t.float    "price"
    t.string   "pict"
    t.string   "quantity"
    t.string   "cat"
    t.string   "cat1"
    t.string   "cat2"
    t.string   "cat3"
    t.string   "cat4"
    t.string   "mtitle"
    t.string   "mdesc"
    t.string   "mkeyw"
    t.string   "p1"
    t.string   "p2"
    t.string   "p3"
    t.string   "p4"
    t.string   "option1"
    t.string   "option2"
    t.string   "option3"
    t.string   "option4"
    t.string   "option5"
    t.string   "option6"
    t.string   "option7"
    t.string   "option8"
    t.string   "option9"
    t.string   "option10"
    t.string   "option11"
    t.string   "option12"
    t.string   "option13"
    t.string   "option14"
    t.boolean  "check",      default: true
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "shulepovs", force: :cascade do |t|
    t.string   "fid"
    t.string   "link"
    t.string   "sku"
    t.string   "title"
    t.string   "sdesc"
    t.string   "desc"
    t.string   "oldprice"
    t.float    "price"
    t.string   "pict"
    t.string   "quantity"
    t.string   "cat"
    t.string   "cat1"
    t.string   "cat2"
    t.string   "cat3"
    t.string   "cat4"
    t.string   "mtitle"
    t.string   "mdesc"
    t.string   "mkeyw"
    t.string   "p1"
    t.string   "p2"
    t.string   "p3"
    t.string   "p4"
    t.string   "option1"
    t.string   "option2"
    t.string   "option3"
    t.string   "option4"
    t.string   "option5"
    t.string   "option6"
    t.string   "option7"
    t.string   "option8"
    t.string   "option9"
    t.string   "option10"
    t.string   "option11"
    t.string   "option12"
    t.string   "option13"
    t.string   "option14"
    t.boolean  "check",      default: true
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "teplodars", force: :cascade do |t|
    t.string   "fid"
    t.string   "link"
    t.string   "sku"
    t.string   "title"
    t.string   "sdesc"
    t.string   "desc"
    t.string   "oldprice"
    t.string   "price"
    t.string   "pict"
    t.string   "quantity"
    t.string   "cat"
    t.string   "cat1"
    t.string   "cat2"
    t.string   "cat3"
    t.string   "cat4"
    t.string   "mtitle"
    t.string   "mdesc"
    t.string   "mkeyw"
    t.string   "p1"
    t.string   "p2"
    t.string   "p3"
    t.string   "p4"
    t.string   "option1"
    t.string   "option2"
    t.string   "option3"
    t.string   "option4"
    t.string   "option5"
    t.string   "option6"
    t.string   "option7"
    t.string   "option8"
    t.string   "option9"
    t.string   "option10"
    t.string   "option11"
    t.string   "option12"
    t.string   "option13"
    t.string   "option14"
    t.boolean  "check",      default: true
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "teplomarkets", force: :cascade do |t|
    t.string   "fid"
    t.string   "link"
    t.string   "sku"
    t.string   "title"
    t.string   "sdesc"
    t.string   "desc"
    t.string   "oldprice"
    t.string   "price"
    t.string   "pict"
    t.string   "quantity"
    t.string   "cat"
    t.string   "cat1"
    t.string   "cat2"
    t.string   "cat3"
    t.string   "cat4"
    t.string   "mtitle"
    t.string   "mdesc"
    t.string   "mkeyw"
    t.string   "p1"
    t.string   "p2"
    t.string   "p3"
    t.string   "p4"
    t.string   "option1"
    t.string   "option2"
    t.string   "option3"
    t.string   "option4"
    t.string   "option5"
    t.string   "option6"
    t.string   "option7"
    t.string   "option8"
    t.string   "option9"
    t.string   "option10"
    t.string   "option11"
    t.string   "option12"
    t.string   "option13"
    t.string   "option14"
    t.boolean  "check",      default: true
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "tmfs", force: :cascade do |t|
    t.string   "fid"
    t.string   "link"
    t.string   "sku"
    t.string   "title"
    t.string   "sdesc"
    t.string   "desc"
    t.string   "oldprice"
    t.float    "price"
    t.string   "pict"
    t.string   "quantity"
    t.string   "cat"
    t.string   "cat1"
    t.string   "cat2"
    t.string   "cat3"
    t.string   "cat4"
    t.string   "mtitle"
    t.string   "mdesc"
    t.string   "mkeyw"
    t.string   "p1"
    t.string   "p2"
    t.string   "p3"
    t.string   "p4"
    t.string   "option1"
    t.string   "option2"
    t.string   "option3"
    t.string   "option4"
    t.string   "option5"
    t.string   "option6"
    t.string   "option7"
    t.string   "option8"
    t.string   "option9"
    t.string   "option10"
    t.string   "option11"
    t.string   "option12"
    t.string   "option13"
    t.string   "option14"
    t.boolean  "check",      default: true
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",     null: false
    t.string   "encrypted_password",     default: "",     null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.string   "name"
    t.string   "role",                   default: "User"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "wellfits", force: :cascade do |t|
    t.string   "fid"
    t.string   "link"
    t.string   "sku"
    t.string   "title"
    t.string   "sdesc"
    t.string   "desc"
    t.string   "oldprice"
    t.string   "price"
    t.string   "pict"
    t.string   "quantity"
    t.string   "cat"
    t.string   "cat1"
    t.string   "cat2"
    t.string   "cat3"
    t.string   "cat4"
    t.string   "mtitle"
    t.string   "mdesc"
    t.string   "mkeyw"
    t.string   "p1"
    t.string   "p2"
    t.string   "p3"
    t.string   "p4"
    t.string   "option1"
    t.string   "option2"
    t.string   "option3"
    t.string   "option4"
    t.string   "option5"
    t.string   "option6"
    t.string   "option7"
    t.string   "option8"
    t.string   "option9"
    t.string   "option10"
    t.string   "option11"
    t.string   "option12"
    t.string   "option13"
    t.string   "option14"
    t.boolean  "check",      default: true
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_foreign_key "products", "contacts"
  add_foreign_key "products", "dantexgroups"
  add_foreign_key "products", "dims"
  add_foreign_key "products", "kovchegs"
  add_foreign_key "products", "lit_koms"
  add_foreign_key "products", "nkamins"
  add_foreign_key "products", "realflames"
  add_foreign_key "products", "saunarus"
  add_foreign_key "products", "sawos"
  add_foreign_key "products", "shulepovs"
  add_foreign_key "products", "teplodars"
  add_foreign_key "products", "teplomarkets"
  add_foreign_key "products", "tmfs"
  add_foreign_key "products", "wellfits"
end
