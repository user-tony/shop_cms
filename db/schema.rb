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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120719073148) do

  create_table "answers", :force => true do |t|
    t.string   "title",          :limit => 50,                 :null => false
    t.string   "content",        :limit => 200
    t.integer  "answer_status",                 :default => 0
    t.string   "remote_ip"
    t.string   "name",           :limit => 40
    t.string   "qq",             :limit => 12
    t.string   "phone",          :limit => 15
    t.string   "address",        :limit => 100
    t.integer  "member_id"
    t.integer  "channel_id"
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
    t.integer  "approval_count",                :default => 0
  end

  create_table "area_cities", :force => true do |t|
    t.integer  "area_province_id"
    t.string   "name"
    t.datetime "deleted_at"
    t.integer  "position"
  end

  create_table "area_countries", :force => true do |t|
    t.integer  "area_city_id"
    t.string   "name"
    t.datetime "deleted_at"
    t.integer  "position"
  end

  create_table "area_provinces", :force => true do |t|
    t.string   "name"
    t.datetime "deleted_at"
    t.integer  "position"
  end

  create_table "article_contents", :force => true do |t|
    t.text     "content"
    t.datetime "deleted_at"
    t.integer  "article_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "article_contents", ["article_id"], :name => "index_article_contents_on_article_id"

  create_table "articles", :force => true do |t|
    t.string   "title",              :limit => 50,                 :null => false
    t.integer  "view_count",                        :default => 0
    t.string   "description",        :limit => 200
    t.integer  "recomment",                         :default => 0
    t.integer  "article_status",                    :default => 0
    t.datetime "deleted_at"
    t.integer  "channel_id"
    t.integer  "member_id"
    t.string   "thumb_file_name"
    t.string   "thumb_content_type"
    t.integer  "thumb_file_size"
    t.datetime "thumb_updated_at"
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
    t.string   "source"
  end

  add_index "articles", ["channel_id"], :name => "index_articles_on_channel_id"
  add_index "articles", ["member_id"], :name => "index_articles_on_member_id"

  create_table "attached_pictures", :force => true do |t|
    t.integer  "item_id"
    t.string   "item_type"
    t.datetime "deleted_at"
    t.string   "thumb_file_name"
    t.string   "thumb_content_type"
    t.integer  "thumb_file_size"
    t.datetime "thumb_updated_at"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "channels", :force => true do |t|
    t.string   "name",               :limit => 20
    t.string   "title",              :limit => 50
    t.string   "keyword",            :limit => 100
    t.string   "description",        :limit => 500
    t.string   "path_customize",     :limit => 30
    t.boolean  "single_page",                       :default => false
    t.boolean  "final_page",                        :default => false
    t.boolean  "show_nav",                          :default => true
    t.integer  "channel_type",                      :default => 0
    t.integer  "info_model_id"
    t.string   "return_url",         :limit => 300
    t.integer  "template_id_index",                 :default => 0
    t.integer  "template_id_list",                  :default => 0
    t.integer  "template_id_detail",                :default => 0
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.string   "thumb_file_name"
    t.string   "thumb_content_type"
    t.integer  "thumb_file_size"
    t.datetime "thumb_updated_at"
    t.datetime "deleted_at"
    t.integer  "position"
    t.datetime "created_at",                                           :null => false
    t.datetime "updated_at",                                           :null => false
    t.integer  "template_single"
  end

  create_table "ckeditor_assets", :force => true do |t|
    t.string   "data_file_name",                  :null => false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    :limit => 30
    t.string   "type",              :limit => 30
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], :name => "idx_ckeditor_assetable"
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], :name => "idx_ckeditor_assetable_type"

  create_table "comments", :force => true do |t|
    t.string   "item_type"
    t.integer  "item_id"
    t.integer  "member_id"
    t.text     "content"
    t.integer  "status"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "custom_page_contents", :force => true do |t|
    t.text     "content",        :limit => 2147483647
    t.integer  "custom_page_id"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

  create_table "custom_pages", :force => true do |t|
    t.string   "name",        :limit => 30
    t.datetime "deleted_at"
    t.string   "description"
    t.integer  "channel_id"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "friendly_websites", :force => true do |t|
    t.string   "name",        :limit => 30, :null => false
    t.string   "website_url",               :null => false
    t.string   "description"
    t.datetime "deleted_at"
    t.integer  "position"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "global_variable_attrachments", :force => true do |t|
    t.integer  "global_variable_id"
    t.datetime "deleted_at"
    t.integer  "position"
    t.string   "thumb_file_name"
    t.string   "thumb_content_type"
    t.integer  "thumb_file_size"
    t.datetime "thumb_updated_at"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "global_variable_categories", :force => true do |t|
    t.string   "name",        :limit => 50
    t.integer  "parent_id",                  :default => 0
    t.integer  "depth",                      :default => 0
    t.string   "description", :limit => 500
    t.integer  "level",                      :default => 0
    t.integer  "position",                   :default => 0
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  create_table "global_variables", :force => true do |t|
    t.string   "name",                        :limit => 50, :null => false
    t.string   "key_name",                    :limit => 50, :null => false
    t.integer  "var_type"
    t.text     "content"
    t.string   "description"
    t.datetime "deleted_at"
    t.integer  "position"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.integer  "global_variable_category_id"
  end

  create_table "info_models", :force => true do |t|
    t.string   "name",              :limit => 100
    t.string   "description"
    t.string   "model_name"
    t.boolean  "info_model_status",                :default => false
    t.datetime "created_at",                                          :null => false
    t.datetime "updated_at",                                          :null => false
  end

  create_table "key_word_filters", :force => true do |t|
    t.string   "content"
    t.string   "replace"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "logistics", :force => true do |t|
    t.integer  "order_id",     :null => false
    t.string   "logistic_com", :null => false
    t.string   "logistic_num", :null => false
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "managers", :force => true do |t|
    t.string   "login",        :limit => 20,                :null => false
    t.string   "password",                                  :null => false
    t.integer  "manager_type",               :default => 0
    t.string   "email",        :limit => 50
    t.datetime "deleted_at"
    t.integer  "position"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  create_table "member_infos", :force => true do |t|
    t.string   "name",            :limit => 50,                     :null => false
    t.integer  "member_id"
    t.boolean  "gender",                         :default => false
    t.datetime "birthday"
    t.datetime "deleted_at"
    t.integer  "position"
    t.integer  "area_country_id"
    t.string   "tel",             :limit => 15
    t.string   "address",         :limit => 100
    t.string   "description",     :limit => 500
  end

  create_table "members", :force => true do |t|
    t.string   "login",                  :limit => 20,                 :null => false
    t.string   "nick_name",              :limit => 20,                 :null => false
    t.integer  "member_type",                          :default => 0
    t.datetime "deleted_at"
    t.integer  "position"
    t.string   "email",                                :default => "", :null => false
    t.string   "encrypted_password",                   :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                        :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                           :null => false
    t.datetime "updated_at",                                           :null => false
  end

  add_index "members", ["email"], :name => "index_members_on_email", :unique => true
  add_index "members", ["reset_password_token"], :name => "index_members_on_reset_password_token", :unique => true

  create_table "order_addresses", :force => true do |t|
    t.integer  "member_id"
    t.integer  "area_country_id"
    t.string   "address"
    t.datetime "deleted_at"
    t.integer  "position"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.string   "name"
    t.string   "phone"
    t.integer  "area_province_id"
    t.integer  "area_city_id"
    t.string   "zip_code"
  end

  create_table "order_products", :force => true do |t|
    t.string   "item_type"
    t.integer  "item_id"
    t.float    "price",      :default => 0.0
    t.integer  "item_count", :default => 0
    t.datetime "deleted_at"
    t.integer  "order_id"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  add_index "order_products", ["order_id"], :name => "index_order_products_on_order_id"

  create_table "orders", :force => true do |t|
    t.float    "amount",           :default => 0.0
    t.float    "payment",          :default => 0.0
    t.integer  "order_status",     :default => 0
    t.integer  "payment_status",   :default => 0
    t.string   "remark"
    t.datetime "deleted_at"
    t.integer  "member_id"
    t.integer  "order_address_id"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.string   "scode"
    t.string   "phone"
    t.string   "recipient_name"
    t.string   "address"
    t.string   "client_ip"
    t.string   "qq"
  end

  add_index "orders", ["member_id"], :name => "index_orders_on_member_id"

  create_table "product_attachments", :force => true do |t|
    t.integer  "position",           :default => 0
    t.integer  "item_id"
    t.datetime "deleted_at"
    t.string   "thumb_file_name"
    t.string   "thumb_content_type"
    t.integer  "thumb_file_size"
    t.datetime "thumb_updated_at"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.string   "item_type",          :default => "0"
  end

  create_table "product_categories", :force => true do |t|
    t.string   "name",           :limit => 30,                 :null => false
    t.integer  "position",                      :default => 0
    t.string   "description",    :limit => 200
    t.datetime "deleted_at"
    t.string   "keyword",        :limit => 100
    t.string   "path_customize", :limit => 30
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "parent_id"
    t.integer  "channel_id"
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
    t.boolean  "parent_node"
  end

  create_table "product_contents", :force => true do |t|
    t.integer  "item_id"
    t.string   "item_type"
    t.text     "content"
    t.datetime "deleted_at"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "products", :force => true do |t|
    t.string   "name",                :limit => 50,                 :null => false
    t.string   "description",         :limit => 200
    t.integer  "position",                           :default => 0
    t.datetime "deleted_at"
    t.string   "product_color"
    t.integer  "product_category_id"
    t.integer  "channel_id"
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
  end

  create_table "reply_answers", :force => true do |t|
    t.string   "content"
    t.integer  "management", :default => 0
    t.integer  "member_id"
    t.integer  "answer_id"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "service_categories", :force => true do |t|
    t.string   "name",                       :null => false
    t.integer  "position",    :default => 0
    t.string   "description"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "service_verifies", :force => true do |t|
    t.string   "serial_number",                      :null => false
    t.string   "password"
    t.integer  "status",              :default => 0
    t.integer  "verify_num",          :default => 0
    t.datetime "verify_at"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.integer  "service_category_id"
  end

  create_table "shop_categories", :force => true do |t|
    t.string   "name",           :limit => 30,                     :null => false
    t.integer  "position",                      :default => 0
    t.string   "description",    :limit => 200
    t.datetime "deleted_at"
    t.string   "keyword",        :limit => 100
    t.string   "path_customize", :limit => 30
    t.boolean  "parent_node",                   :default => false
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "parent_id"
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
  end

  create_table "shop_packages", :force => true do |t|
    t.string   "name"
    t.float    "market_price",   :default => 0.0
    t.float    "price",          :default => 0.0
    t.integer  "product_status", :default => 0
    t.integer  "stock",          :default => 0
    t.integer  "position",       :default => 0
    t.datetime "deleted_at"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  create_table "shop_product_category_relations", :force => true do |t|
    t.integer  "shop_category_id"
    t.integer  "shop_product_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "shop_product_package_relations", :force => true do |t|
    t.integer  "product_count"
    t.datetime "deleted_at"
    t.integer  "shop_package_id"
    t.integer  "shop_product_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "shop_product_package_relations", ["shop_package_id"], :name => "index_shop_product_package_relations_on_shop_package_id"
  add_index "shop_product_package_relations", ["shop_product_id"], :name => "index_shop_product_package_relations_on_shop_product_id"

  create_table "shop_products", :force => true do |t|
    t.string   "name",              :limit => 100
    t.float    "market_price",                     :default => 0.0
    t.float    "price",                            :default => 0.0
    t.integer  "product_status",                   :default => 0
    t.integer  "stock",                            :default => 0
    t.integer  "position",                         :default => 0
    t.datetime "deleted_at"
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
    t.integer  "product_id",                       :default => 0
    t.integer  "shop_product_type"
    t.float    "try_price",                        :default => 0.0
    t.string   "description"
    t.integer  "recommend",                        :default => 0
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       :limit => 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "template_categories", :force => true do |t|
    t.string   "name"
    t.integer  "group_id"
    t.string   "description"
    t.integer  "sort_id",       :default => 0
    t.integer  "type_id",       :default => 0
    t.integer  "info_model_id"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  create_table "templates", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.text     "content"
    t.integer  "template_type",        :limit => 2, :default => 0
    t.boolean  "template_status",                   :default => false
    t.integer  "info_model_id"
    t.datetime "created_at",                                           :null => false
    t.datetime "updated_at",                                           :null => false
    t.string   "template_name"
    t.integer  "template_category_id"
  end

  create_table "zhaopins", :force => true do |t|
    t.string   "position",     :default => "0"
    t.string   "education"
    t.string   "age"
    t.string   "experience"
    t.string   "salary"
    t.string   "contact_user"
    t.string   "contact_tel"
    t.string   "description"
    t.datetime "deleted_at"
    t.integer  "member_id"
    t.integer  "channel_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

end
