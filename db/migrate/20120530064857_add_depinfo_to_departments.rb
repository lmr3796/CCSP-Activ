class AddDepinfoToDepartments < ActiveRecord::Migration
  def change
	add_column :departments, :dep_subtitle, :string
	add_column :departments, :dep_description, :text
	add_column :departments, :dep_image_url, :text
	add_column :activities, :act_subtitle, :string
	add_column :activities, :act_description, :text
	add_column :activities, :act_image_url, :text
  end
end
