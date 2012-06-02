class RemoveLightJsonFromActivity < ActiveRecord::Migration
  def up
    remove_column :activities, :light_json
      end

  def down
    add_column :activities, :light_json, :text
  end
end
