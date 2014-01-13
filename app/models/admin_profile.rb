# == Schema Information
#
# Table name: admin_profiles
#
#  id            :integer          not null, primary key
#  about         :string(255)
#  position      :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  admin_id      :integer
#  super_user_id :integer
#

class AdminProfile < ActiveRecord::Base
  attr_accessible :about, :position, :admin_id
  belongs_to :admin

  validates :about, presence: true, on: :update
  validates :position, presence: true, on: :update
end
