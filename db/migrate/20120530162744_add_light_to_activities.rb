class AddLightToActivities < ActiveRecord::Migration
  def change
	add_column :activities, :music_url, :text
	add_column :activities, :light_json, :text
  end
end
