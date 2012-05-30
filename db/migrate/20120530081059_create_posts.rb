class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :event_id
      t.integer :dep_id
      t.integer :act_id
      t.string	:title
      t.text    :content
      t.integer	:user_id
      t.timestamps
    end
  end
end
