class Activity < ActiveRecord::Base
  attr_accessible :act_head, :act_name, :event_id,:calendar_id
  validates :act_head,:act_name,:event_id, :presence => true
  belongs_to :event
  has_many :user_activities
  has_many :users, :through => :user_activities 
  has_many :accountings
end
