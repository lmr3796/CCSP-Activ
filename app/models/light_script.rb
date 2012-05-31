class LightScript < ActiveRecord::Base
  belongs_to :activity
  attr_accessible :move, :time
end
