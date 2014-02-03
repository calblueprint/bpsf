class AddStatusFieldsToGrants < ActiveRecord::Migration
  def change
    add_column :grants, :crowdfunding, :boolean, default: false
    add_column :grants, :crowdfund_pending, :boolean, default: false
    add_column :grants, :pending, :boolean, default: true
    add_column :grants, :complete, :boolean, default: false
    add_column :grants, :rejected, :boolean, default: false
  end
end
