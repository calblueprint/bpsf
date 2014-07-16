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

  scope :updated_in_range, ->(start_date, end_date) {
    where("updated_at between ? and ?", start_date, end_date)
  }

  CSV_COLUMNS = ['Name', 'Email', 'Street', 'City', 'Zipcode', 'Teacher Name', 'Project Name', 'Amount', 'Date', 'Credit Card Transaction Success']

  def self.make_payment!(amount, grant, current_user)
    payment = current_user.payments.build amount: amount
    payment.user_id = current_user.id
    payment.crowdfund_id = grant.crowdfunder.id
    payment.crowdfund.add_payment payment.amount
    payment.status = "Pledged"
    UserPledgeJob.new.async.perform(current_user,grant, payment)
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

  def self.to_csv(payments)
    CSV.generate do |csv|
      csv << CSV_COLUMNS
      payments.each do |payment|
        csv << payment.to_csv
      end
    end
  end

  def to_csv
    profile = user.profile
    grant = crowdfund.grant
    recipient = grant.recipient
    [user.name, user.email, profile.address, profile.city, profile.zipcode,
     recipient.name, grant.title, amount, created_at, 'YES']
  end
end
