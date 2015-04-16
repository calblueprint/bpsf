class AddGrantIdToPreapprovedGrant < ActiveRecord::Migration
  def change
    add_column :draft_grants, :grant_id, :integer
    add_index :draft_grants, :grant_id
  end
end
