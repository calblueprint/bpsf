class AddIndiciesToTables < ActiveRecord::Migration
  def change
    add_index :grants, :school_id
    add_index :grants, :recipient_id
    add_index :draft_grants, :school_id
    add_index :draft_grants, :recipient_id
    add_index :payments, :user_id
    add_index :payments, :crowdfund_id
  end
end
