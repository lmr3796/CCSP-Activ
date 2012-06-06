class AddDocLinkToActivity < ActiveRecord::Migration
  def change
       add_column :activities, :doc_link, :text
  end
end
