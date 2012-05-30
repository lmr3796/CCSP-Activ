class AddTrailerUrl < ActiveRecord::Migration
  def change
	 add_column :events, :event_trailer_url, :string
  end

end
