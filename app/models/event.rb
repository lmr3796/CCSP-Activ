class Event < ActiveRecord::Base
  attr_accessible :event_end, :event_head, :event_name, :event_start, :organization_id
  has_many :user_events
  has_many :users, :through => :user_events
  belongs_to :organization
  has_many :departments
  has_many :activities
  has_many :accountings
  validates :event_name, :event_head, :organization_id, :presence => true
  validates :event_name, :uniqueness => true
end
