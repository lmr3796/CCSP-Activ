class CreateAccountings < ActiveRecord::Migration
  def change
    create_table :accountings do |t|
      t.string :title
      t.integer :balance
      t.integer :event_id
      t.integer :activity_id
      t.integer :department_id
      t.integer :user_id
      t.string :receipt
      t.text :comment
      t.boolean :approved
      t.boolean :paid

      t.timestamps
    end
  end
end
