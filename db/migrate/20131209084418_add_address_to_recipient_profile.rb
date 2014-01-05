class AddAddressToRecipientProfile < ActiveRecord::Migration
  def change
    add_column :recipient_profiles, :address, :string
    add_column :recipient_profiles, :city, :string
    add_column :recipient_profiles, :zipcode, :integer
  end
end
