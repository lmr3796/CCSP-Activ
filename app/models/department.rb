class Department < ActiveRecord::Base
  attr_accessible :dep_head, :dep_name, :event_id,:calendar_id
  validates :dep_head,:dep_name,:event_id, :presence => true
  belongs_to :event
  has_many :user_departments
  has_many :users, :through => :user_departments 
  has_many :accountings
  
end
