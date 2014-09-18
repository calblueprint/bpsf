class RemoveRequestedFundsFromGrants < ActiveRecord::Migration
  def up
    remove_column :grants, :requested_funds
  end

  def down
    add_column :grants, :requested_funds, :integer
  end
end
