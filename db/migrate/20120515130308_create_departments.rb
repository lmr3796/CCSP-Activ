class CreateDepartments < ActiveRecord::Migration
  def change
    create_table :departments do |t|
      t.string :dep_name
      t.integer :dep_head
      t.integer :event_id

      t.timestamps
    end
  end
end
