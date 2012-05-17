class User < ActiveRecord::Base
  attr_accessible :fb_id, :email, :username
  validates :email, :uniqueness => true
  validates :email, :presence => true
  has_many :user_events
  has_many :events, :through => :user_events
  has_many :user_departments
  has_many :departments, :through => :user_departments
  has_many :user_activities
  has_many :activities, :through => :user_activities
 
end
