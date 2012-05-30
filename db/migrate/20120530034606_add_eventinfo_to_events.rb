class AddEventinfoToEvents < ActiveRecord::Migration
  def change
	add_column :events, :event_subtitle, :string
	add_column :events, :event_description, :text
	add_column :events, :event_image_url, :text
  end
end
