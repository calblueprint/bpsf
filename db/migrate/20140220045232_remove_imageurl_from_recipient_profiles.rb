class RemoveImageurlFromRecipientProfiles < ActiveRecord::Migration
  def up
    remove_column :recipient_profiles, :image_url
  end

  def down
    add_column :recipient_profiles, :image_url, :string
  end
end
