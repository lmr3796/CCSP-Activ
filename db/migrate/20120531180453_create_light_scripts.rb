class CreateLightScripts < ActiveRecord::Migration
  def change
    create_table :light_scripts do |t|
      t.references :activity
      t.float :time
      t.string :move

      t.timestamps
    end
    add_index :light_scripts, :activity_id
  end
end
