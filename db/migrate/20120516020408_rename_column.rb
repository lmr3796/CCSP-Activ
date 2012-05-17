class RenameColumn < ActiveRecord::Migration
  def change
	rename_column :users, :nickname, :email
  end

end
