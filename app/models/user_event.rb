class UserEvent < ActiveRecord::Base
  attr_accessible :event_id, :role, :user_id
  belongs_to :user
  belongs_to :event
end
