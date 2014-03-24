class AddAddressDetailsToAdminProfiles < ActiveRecord::Migration
  def change
    add_column :admin_profiles, :address, :text
    add_column :admin_profiles, :city, :text
    add_column :admin_profiles, :zipcode, :text
    add_column :admin_profiles, :state, :text
  end
end
