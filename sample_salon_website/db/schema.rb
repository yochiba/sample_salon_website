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

ActiveRecord::Schema.define(version: 2019_07_20_174253) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string "adminid", null: false
    t.string "lastname", null: false
    t.string "firstname", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "userlevelflg", default: 0, null: false
  end

  create_table "appointments", force: :cascade do |t|
    t.string "firstname", default: "pending", null: false
    t.string "lastname", default: "pending", null: false
    t.string "email", default: "pending@pending", null: false
    t.string "servicename", default: "pending", null: false
    t.datetime "startdate", default: -> { "now()" }, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "staffname", default: "指名なし"
    t.integer "totalservicetime", default: 0, null: false
    t.integer "totalserviceprice", default: 0
    t.integer "totaltoken", default: 0, null: false
    t.datetime "enddate"
    t.integer "staffid"
    t.integer "starttokenid", default: 0
    t.string "displaydate", default: "nodisplay time"
  end

  create_table "contacts", force: :cascade do |t|
    t.string "firstname", null: false
    t.string "lastname", null: false
    t.string "email", null: false
    t.text "message", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "customers", force: :cascade do |t|
    t.string "firstname", null: false
    t.string "lastname", null: false
    t.integer "gender"
    t.integer "age"
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "userid", null: false
  end

  create_table "services", force: :cascade do |t|
    t.string "servicename", null: false
    t.string "servicetypename", null: false
    t.integer "serviceflg", default: 0, null: false
    t.integer "servicetime", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "servicekeyword", null: false
    t.integer "serviceprice", null: false
    t.string "serviceimage", default: "default.jpg"
  end

  create_table "staffs", force: :cascade do |t|
    t.string "firstname"
    t.string "lastname"
    t.string "email"
    t.string "displayname", default: "Noname"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
