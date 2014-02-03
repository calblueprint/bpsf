class RemoveUserIdFromGrants < ActiveRecord::Migration
  def up
    remove_column :grants, :user_id
  end

  def down
    add_column :grants, :user_id, :integer
  end
end
