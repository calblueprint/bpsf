# == Schema Information
#
# Table name: crowdfunds
#
#  id            :integer          not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  goal          :integer
#  pledged_total :integer
#  grant_id      :integer
#  eighty        :boolean
#  finished      :boolean
#

class Crowdfund < ActiveRecord::Base
  attr_accessible :goal, :pledged_total, :grant_id, :finished, :eighty
  has_many :payments
  belongs_to :grant

  def progress
    "#{([self.pledged_total/self.goal.to_f, 1].min * 100).to_i}%"
  end

  def past_goal
    self.pledged_total >= self.goal
  end

  def past_80
    (self.pledged_total >= (self.goal * 0.8)) && (self.pledged_total < self.goal)
  end

  def add_payment(amount)
    self.pledged_total = self.pledged_total + amount
    self.save!
  end
end
