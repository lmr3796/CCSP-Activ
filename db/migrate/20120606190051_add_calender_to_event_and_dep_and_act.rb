class AddCalenderToEventAndDepAndAct < ActiveRecord::Migration
  def change
	add_column :events, :calendar_id , :string
	add_column :departments, :calendar_id , :string
	add_column :activities, :calendar_id , :string
  end
end
