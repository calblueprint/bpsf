class RemoveTypeFromGrants < ActiveRecord::Migration
  def up
    remove_column :grants, :type
  end

  def down
    add_column :grants, :type, :string
  end
end
