class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :nickname
      t.string :fb_id

      t.timestamps
    end
  end
end
