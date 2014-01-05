class RecipientsBelongToSchool < ActiveRecord::Migration
  def change
    add_column :users, :school_id, :integer
    add_index :users, :school_id
  end
end
