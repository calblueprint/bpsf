# == Schema Information
#
# Table name: admin_profiles
#
#  id            :integer          not null, primary key
#  about         :string(255)
#  position      :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  address       :text
#  city          :text
#  zipcode       :text
#  state         :text
#  super_user_id :integer
#  admin_id      :integer
#

class AdminProfile < ActiveRecord::Base
  attr_accessible :about, :position, :admin_id, :address, :city, :state, :zipcode
  belongs_to :admin

  validates :about, presence: true, on: :update
  validates :position, presence: true, on: :update
  validates :address, presence: true, on: :update
  validates :city, presence: true, on: :update
  validates :state, presence: true, on: :update
  validates :zipcode, length: { minimum: 5, message: 'is an invalid zipcode' }, presence: true, on: :update

end
