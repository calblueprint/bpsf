class AddTypeToGrant < ActiveRecord::Migration
  def change
    add_column :grants, :type, :string
  end
end
