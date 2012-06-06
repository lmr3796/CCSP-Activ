class CreateLightRepeats < ActiveRecord::Migration
  def change
    create_table :light_repeats do |t|
      t.references :activity
      t.string :name
      t.float :start
      t.float :end

      t.timestamps
    end
    add_index :light_repeats, :activity_id
  end
end
