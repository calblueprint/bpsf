class AddStateToGrant < ActiveRecord::Migration
  def change
    add_column :grants, :state, :string
  end
end
