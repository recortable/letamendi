# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20081202172430) do

  create_table "list_items", :force => true do |t|
    t.string  "name"
    t.integer "parent"
  end

  create_table "members", :force => true do |t|
    t.string  "name"
    t.string  "address"
    t.string  "email"
    t.string  "telephone"
    t.integer "number"
    t.string  "comments"
    t.string  "friends"
    t.integer "rent_count"
  end

  create_table "movies", :force => true do |t|
    t.string  "title"
    t.string  "director"
    t.string  "genre"
    t.string  "crew"
    t.integer "year"
    t.integer "number"
    t.string  "section"
    t.integer "rent_count"
  end

  create_table "rent_items", :force => true do |t|
    t.integer "rent_id"
    t.integer "movie_id"
    t.boolean "closed"
    t.float   "price"
  end

  create_table "rents", :force => true do |t|
    t.integer  "member_id"
    t.boolean  "closed"
    t.datetime "begin_date"
    t.datetime "end_date"
    t.datetime "close_date"
    t.float    "price"
    t.float    "extra"
    t.integer  "prorrogue"
  end

  add_index "rents", ["begin_date"], :name => "rents_begin_date_index"
  add_index "rents", ["closed"], :name => "rents_closed_index"
  add_index "rents", ["end_date"], :name => "rents_end_date_index"

  create_table "schema_info", :id => false, :force => true do |t|
    t.integer "version"
  end

end
