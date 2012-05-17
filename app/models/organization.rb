class Organization < ActiveRecord::Base
  attr_accessible :org_name
  validates :org_name, :presence => true
  validates :org_name, :uniqueness => true
  has_many :events
end
