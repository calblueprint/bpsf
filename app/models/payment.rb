class Payment < ActiveRecord::Base
  attr_accessible :amount
  belongs_to :user
  belongs_to :crowdfund
end
