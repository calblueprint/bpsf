class AddRecipientIdToRecipientProfile < ActiveRecord::Migration
  def change
    add_column :recipient_profiles, :recipient_id, :integer
  end
end
