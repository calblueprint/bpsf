class RemoveRequestedFundsFromDraftGrants < ActiveRecord::Migration
  def up
    remove_column :draft_grants, :requested_funds
  end

  def down
    add_column :draft_grants, :requested_funds, :integer
  end
end
