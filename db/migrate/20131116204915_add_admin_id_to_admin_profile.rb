class AddAdminIdToAdminProfile < ActiveRecord::Migration
  def change
    add_column :admin_profiles, :admin_id, :integer
  end
end
