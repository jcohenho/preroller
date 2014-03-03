ActiveRecord::Schema.define do

  create_table "preroller_audio_encodings", :force => true do |t|
    t.integer  "campaign_id", :null => false
    t.string   "stream_key",  :null => false
    t.string   "fingerprint"
    t.string   "extension"
    t.integer  "size"
    t.integer  "duration"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "type"
    t.integer  "sample_rate"
    t.integer  "bitrate"
    t.integer  "profile"
    t.integer  "channels"
  end

  add_index "preroller_audio_encodings", ["campaign_id", "stream_key"], :name => "index_preroller_audio_encodings_on_campaign_id_and_stream_key", :unique => true

  create_table "preroller_campaigns", :force => true do |t|
    t.string   "title",                          :null => false
    t.string   "metatitle"
    t.boolean  "active",      :default => false, :null => false
    t.datetime "start_at",                       :null => false
    t.datetime "end_at",                         :null => false
    t.integer  "output_id",                      :null => false
    t.string   "path_filter"
    t.string   "ua_filter"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "preroller_campaigns", ["output_id"], :name => "index_preroller_campaigns_on_output_id"

  create_table "preroller_outputs", :force => true do |t|
    t.string   "key",         :null => false
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

end
