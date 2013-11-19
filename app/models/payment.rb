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

  def self.make_payment!(amount, grant, current_user)
    payment = current_user.payments.build amount: amount
    payment.user_id = current_user.id
    payment.crowdfund_id = grant.crowdfunder.id
    payment.save!
    UserMailer.user_pledge(current_user,grant).deliver
  end
end
