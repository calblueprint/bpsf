class AdminProfile < ActiveRecord::Base
  attr_accessible :about, :position, :admin_id
  belongs_to :admin
end
