class RemoveOrganizationFromGrants < ActiveRecord::Migration
  def up
    remove_column :grants, :organization
  end

  def down
    add_column :grants, :organization, :string
  end
end
