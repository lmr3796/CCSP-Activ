class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :act_name
      t.integer :act_head
      t.integer :event_id

      t.timestamps
    end
  end
end
