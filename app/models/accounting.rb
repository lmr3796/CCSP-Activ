class Accounting < ActiveRecord::Base
  attr_accessible :activity_id, :approved, :balance, :comment, :department_id, :event_id, :paid, :receipt, :title, :user_id
belongs_to :event
belongs_to :activity
belongs_to :department
end
