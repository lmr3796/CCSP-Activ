class Post < ActiveRecord::Base
   attr_accessible :title, :content, :user_id, :event_id, :dep_id, :act_id
   validates :event_id, :user_id, :title, :presence => true
end
