class LightRepeat < ActiveRecord::Base
  belongs_to :activity
  attr_accessible :end, :name, :start
end
