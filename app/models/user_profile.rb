# == Schema Information
#
# Table name: user_profiles
#
#  id           :integer          not null, primary key
#  address      :text
#  phone        :text
#  relationship :text
#  user_id      :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class UserProfile < ActiveRecord::Base
  attr_accessible :address, :phone, :relationship, :user_id
end
