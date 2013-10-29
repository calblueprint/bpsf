# == Schema Information
#
# Table name: payments
#
#  id           :integer          not null, primary key
#  amount       :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :integer
#  crowdfund_id :integer
#  charge_id    :string(255)
#

class Payment < ActiveRecord::Base
  attr_accessible :amount
  belongs_to :user
  belongs_to :crowdfund
end
