class AddGoalAndPledgedTotalToCrowdfund < ActiveRecord::Migration
  def change
    add_column :crowdfunds, :goal, :integer
    add_column :crowdfunds, :pledged_total, :integer
  end
end
