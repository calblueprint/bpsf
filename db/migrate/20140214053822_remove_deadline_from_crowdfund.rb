class RemoveDeadlineFromCrowdfund < ActiveRecord::Migration
  def up
    remove_column :crowdfunds, :deadline
  end

  def down
    add_column :crowdfunds, :deadline, :datetime
  end
end
