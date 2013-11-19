class AddSuperUserIdToAdminProfiles < ActiveRecord::Migration
  def change
    add_column :admin_profiles, :super_user_id, :integer
  end
end
