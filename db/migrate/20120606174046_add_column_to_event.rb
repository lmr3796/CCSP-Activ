class AddColumnToEvent < ActiveRecord::Migration
  def change
	add_column :events, :accounting_manager_id, :integer
  end
end
