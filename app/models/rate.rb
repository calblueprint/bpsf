# == Schema Information
#
# Table name: rates
#
#  id            :integer          not null, primary key
#  rater_id      :integer
#  rateable_id   :integer
#  rateable_type :string(255)
#  stars         :integer          not null
#  dimension     :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Rate < ActiveRecord::Base
  belongs_to :rater, :class_name => "Admin"
  belongs_to :rateable, :polymorphic => true
  validates_numericality_of :stars, :minimum => 1

  attr_accessible :rate, :dimension
end
