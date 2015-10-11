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
#  status       :text
#

class Payment < ActiveRecord::Base
  attr_accessible :amount, :status
  belongs_to :user
  belongs_to :crowdfund

  validates :amount, numericality: {greater_than: 0}

  def self.make_payment!(amount, grant, current_user, donor_name = '')
    payment = current_user.payments.build amount: amount
    payment.user_id = current_user.id
    payment.crowdfund_id = grant.crowdfunder.id
    payment.crowdfund.add_payment payment.amount
    if donor_name.blank?
      payment.status = "Pledged"
      UserPledgeJob.new.async.perform(current_user,grant, payment)
    else
      payment.status = "Charged"
      payment.charge_id = donor_name
    end
    if payment.crowdfund.past_goal && payment.crowdfund.finished.blank?
      payment.crowdfund.finished = true
      payment.crowdfund.save!
      @supers = SuperUser.all
      @supers.each do |admin|
        GoalMetJob.new.async.perform(grant, admin)
      end
    elsif payment.crowdfund.past_80 && payment.crowdfund.eighty.blank?
      payment.crowdfund.eighty = true
      payment.crowdfund.save!
      @payments = payment.crowdfund.payments
      @payments.each do |payment|
        DonorNearendJob.new.async.perform(grant,payment.user)
      end
    end
    payment
  end

  def dollars_amount
    "$%05.2f" % self.amount
  end
end
