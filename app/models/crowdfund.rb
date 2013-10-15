class Crowdfund < ActiveRecord::Base
  attr_accessible :deadline, :goal, :pledged_total
end
