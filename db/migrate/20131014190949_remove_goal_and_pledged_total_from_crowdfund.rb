class RemoveGoalAndPledgedTotalFromCrowdfund < ActiveRecord::Migration
  def up
    remove_column :crowdfunds, :goal
    remove_column :crowdfunds, :pledged_total
  end

  def down
    add_column :crowdfunds, :pledged_total, :decimal
    add_column :crowdfunds, :goal, :decimal
  end
end
