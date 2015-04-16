class AddRecipientIdToGrants < ActiveRecord::Migration
  def change
    add_column :grants, :recipient_id, :integer
  end
end
