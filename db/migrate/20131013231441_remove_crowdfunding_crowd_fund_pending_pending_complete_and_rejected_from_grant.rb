class RemoveCrowdfundingCrowdFundPendingPendingCompleteAndRejectedFromGrant < ActiveRecord::Migration
  def up
    remove_column :grants, :crowdfunding
    remove_column :grants, :crowdfund_pending
    remove_column :grants, :pending
    remove_column :grants, :complete
    remove_column :grants, :rejected
  end

  def down
    add_column :grants, :rejected, :boolean
    add_column :grants, :complete, :boolean
    add_column :grants, :pending, :booelan
    add_column :grants, :crowdfund_pending, :boolean
    add_column :grants, :crowdfunding, :boolean
  end
end
