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
  attr_accessible :amount, :status
  belongs_to :user
  belongs_to :crowdfund

  validates :amount, numericality: {greater_than: 0}

  def self.make_payment!(amount, grant, current_user)
    payment = current_user.payments.build amount: amount
    payment.user_id = current_user.id
    payment.crowdfund_id = grant.crowdfunder.id
    payment.crowdfund.add_payment payment.amount
    payment.status = "Pledged"
    UserPledgeJob.new.async.perform(current_user,grant, payment)
    payment
  end

  def dollars_amount
    "$%05.2f" % self.amount
  end
end
