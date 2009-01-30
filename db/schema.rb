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

ActiveRecord::Schema.define(:version => 20081222173518) do

  create_table "login_tickets", :force => true do |t|
    t.string   "value",       :limit => 255, :null => false
    t.datetime "consumed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "service_tickets", :force => true do |t|
    t.belongs_to :ticket_granting_cookie
    t.string   "value",       :limit => 255, :null => false
    t.string   "username",                  :null => false
    t.string   "service",     :limit => 255, :null => false
    t.datetime "consumed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ticket_granting_cookies", :force => true do |t|
    t.string   "value",       :limit => 255, :null => false
    t.string   "username",                  :null => false
    t.datetime "consumed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     :extra_attributes, :null => true, :default => nil
  end

end
