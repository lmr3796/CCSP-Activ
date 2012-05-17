class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :event_name
      t.date :event_start
      t.date :event_end
      t.integer :event_head
      t.integer :organization_id

      t.timestamps
    end
  end
end
