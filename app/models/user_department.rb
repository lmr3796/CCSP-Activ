class UserDepartment < ActiveRecord::Base
  attr_accessible :department_id, :user_id
  belongs_to :user
  belongs_to :department
end
