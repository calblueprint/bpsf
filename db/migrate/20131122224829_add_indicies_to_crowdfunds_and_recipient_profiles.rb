class AddIndiciesToCrowdfundsAndRecipientProfiles < ActiveRecord::Migration
  def change
    add_index :admin_profiles, :admin_id
    add_index :admin_profiles, :super_user_id
    add_index :recipient_profiles, :school_id
    add_index :crowdfunds, :grant_id
  end
end
