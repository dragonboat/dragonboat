# This file is autogenerated. Instead of editing this file, please use the
# migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.

ActiveRecord::Schema.define(:version => 77) do

  create_table "answers", :force => true do |t|
    t.integer  "ticket_id"
    t.string   "subject"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "answers", ["ticket_id"], :name => "index_answers_on_ticket_id"

  create_table "boat_types", :force => true do |t|
    t.string   "name"
    t.integer  "price_in_cents"
    t.boolean  "is_active",      :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "boat_types", ["is_active"], :name => "index_boat_types_on_is_active"

  create_table "comatose_pages", :force => true do |t|
    t.integer  "parent_id"
    t.text     "full_path"
    t.string   "title"
    t.string   "slug"
    t.string   "keywords"
    t.text     "body"
    t.string   "filter_type", :limit => 25, :default => "Textile"
    t.string   "author"
    t.integer  "position",                  :default => 0
    t.integer  "version"
    t.datetime "updated_on"
    t.datetime "created_on"
    t.boolean  "is_page",                   :default => true
    t.string   "notice"
  end

  add_index "comatose_pages", ["is_page"], :name => "index_comatose_pages_on_is_page"

  create_table "data_files", :force => true do |t|
    t.integer  "parent_id"
    t.string   "content_type"
    t.string   "filename"
    t.string   "thumbnail"
    t.integer  "size"
    t.integer  "width"
    t.integer  "height"
    t.text     "description"
    t.integer  "created_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "data_files", ["created_by"], :name => "index_data_files_on_created_by"
  add_index "data_files", ["parent_id"], :name => "index_data_files_on_parent_id"

  create_table "events", :force => true do |t|
    t.datetime "start_date"
    t.string   "name"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "extras", :force => true do |t|
    t.string   "name"
    t.integer  "price_in_cents"
    t.text     "notice"
    t.boolean  "is_available",   :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "extras", ["is_available"], :name => "index_extras_on_is_available"

  create_table "extras_orders", :force => true do |t|
    t.integer  "order_id"
    t.integer  "extras_id"
    t.string   "extras_type"
    t.integer  "pay"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "quantity"
  end

  create_table "images", :force => true do |t|
    t.integer  "parent_id"
    t.string   "content_type"
    t.string   "filename"
    t.string   "thumbnail"
    t.integer  "size"
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by"
    t.text     "description"
  end

  add_index "images", ["created_by"], :name => "index_images_on_created_by"

  create_table "member_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "members", :force => true do |t|
    t.integer  "type_id"
    t.integer  "user_id"
    t.integer  "invitation_status_id"
    t.integer  "waiver_status_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "team_id"
    t.string   "sign_waiver_notice"
    t.string   "ip",                   :default => ""
    t.datetime "waiver_sign_at"
  end

  add_index "members", ["type_id"], :name => "index_members_on_type_id"
  add_index "members", ["user_id"], :name => "index_members_on_user_id"
  add_index "members", ["invitation_status_id"], :name => "index_members_on_invitation_status_id"
  add_index "members", ["waiver_status_id"], :name => "index_members_on_waiver_status_id"
  add_index "members", ["team_id"], :name => "index_members_on_team_id"

  create_table "news", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.text     "content"
    t.integer  "cover_image_id"
    t.boolean  "is_short"
    t.boolean  "is_visible",      :default => true
    t.boolean  "data_is_visible", :default => true
    t.integer  "created_by"
    t.datetime "created_at"
    t.datetime "published_at"
    t.datetime "updated_at"
  end

  add_index "news", ["cover_image_id"], :name => "index_news_on_cover_image_id"
  add_index "news", ["created_by"], :name => "index_news_on_created_by"
  add_index "news", ["is_visible"], :name => "index_news_on_is_visible"
  add_index "news", ["is_short"], :name => "index_news_on_is_short"
  add_index "news", ["data_is_visible"], :name => "index_news_on_data_is_visible"

  create_table "orders", :force => true do |t|
    t.integer  "user_id"
    t.integer  "team_id"
    t.string   "customer_ip"
    t.text     "gateway_message"
    t.string   "phone_number"
    t.string   "status"
    t.text     "credit_card"
    t.integer  "boat_pay"
    t.integer  "total_pay"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "billing_id"
  end

  add_index "orders", ["user_id"], :name => "index_orders_on_user_id"
  add_index "orders", ["team_id"], :name => "index_orders_on_team_id"
  add_index "orders", ["billing_id"], :name => "index_orders_on_billing_id"

  create_table "orphaned_paddlers", :force => true do |t|
    t.integer  "person_id"
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "orphaned_paddlers", ["person_id"], :name => "index_orphaned_paddlers_on_person_id"

  create_table "page_versions", :force => true do |t|
    t.integer  "page_id"
    t.integer  "version"
    t.integer  "parent_id"
    t.text     "full_path"
    t.string   "title"
    t.string   "slug"
    t.string   "keywords"
    t.text     "body"
    t.string   "filter_type", :limit => 25, :default => "Textile"
    t.string   "author"
    t.integer  "position",                  :default => 0
    t.datetime "updated_on"
    t.datetime "created_on"
    t.boolean  "is_page",                   :default => true
    t.string   "notice"
  end

  add_index "page_versions", ["is_page"], :name => "index_page_versions_on_is_page"

  create_table "persons", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "phone"
    t.string   "phone_2"
    t.date     "birthday_date"
    t.string   "zip"
    t.string   "address"
    t.text     "experience"
    t.text     "preference"
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "address2"
    t.string   "gender"
  end

  create_table "practices", :force => true do |t|
    t.integer  "team_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "practices", ["team_id"], :name => "index_practices_on_team_id"

  create_table "roles", :force => true do |t|
    t.string "name"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  add_index "roles_users", ["role_id"], :name => "index_roles_users_on_role_id"
  add_index "roles_users", ["user_id"], :name => "index_roles_users_on_user_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :default => "", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "statuses", :force => true do |t|
    t.string   "name"
    t.string   "status_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", :force => true do |t|
    t.integer "tag_id"
    t.integer "taggable_id"
    t.string  "taggable_type"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type"], :name => "index_taggings_on_tag_id_and_taggable_id_and_taggable_type"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  add_index "tags", ["name"], :name => "index_tags_on_name"

  create_table "team_extras", :force => true do |t|
    t.integer  "extras_id"
    t.integer  "team_id"
    t.integer  "quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "team_extras", ["extras_id"], :name => "index_team_extras_on_extras_id"
  add_index "team_extras", ["team_id"], :name => "index_team_extras_on_team_id"

  create_table "teams", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "captain_id"
    t.integer  "logo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status_id",   :default => 14
    t.integer  "type_id"
    t.string   "url"
    t.string   "human_name"
  end

  add_index "teams", ["captain_id"], :name => "index_teams_on_captain_id"
  add_index "teams", ["logo_id"], :name => "index_teams_on_logo_id"
  add_index "teams", ["status_id"], :name => "index_teams_on_status_id"
  add_index "teams", ["type_id"], :name => "index_teams_on_type_id"

  create_table "tents", :force => true do |t|
    t.integer  "team_id"
    t.string   "location"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tents", ["team_id"], :name => "index_tents_on_team_id"

  create_table "tickets", :force => true do |t|
    t.integer  "parent_id"
    t.integer  "user_id"
    t.string   "email"
    t.string   "subject"
    t.string   "priority",    :limit => 50
    t.string   "status",      :limit => 50
    t.text     "message"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tickets", ["parent_id"], :name => "index_tickets_on_parent_id"
  add_index "tickets", ["priority"], :name => "index_tickets_on_priority"

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.integer  "person_id"
  end

  add_index "users", ["person_id"], :name => "index_users_on_person_id"

  create_table "volunteer_options", :force => true do |t|
    t.integer "volunteer_id"
    t.string  "option_type"
    t.string  "option"
    t.time    "from"
    t.time    "to"
  end

  add_index "volunteer_options", ["volunteer_id"], :name => "index_volunteer_options_on_volunteer_id"

  create_table "volunteers", :force => true do |t|
    t.integer  "person_id"
    t.datetime "date_applied"
    t.integer  "status_id"
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "have_you_volunteered_before"
  end

  add_index "volunteers", ["person_id"], :name => "index_volunteers_on_person_id"
  add_index "volunteers", ["status_id"], :name => "index_volunteers_on_status_id"

end
