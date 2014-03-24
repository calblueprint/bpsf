class AddStateToRecipientProfiles < ActiveRecord::Migration
  def change
    add_column :recipient_profiles, :state, :text
  end
end
