class UserProfile < ActiveRecord::Base
  attr_accessible :address, :phone, :relationship, :user_id
end
