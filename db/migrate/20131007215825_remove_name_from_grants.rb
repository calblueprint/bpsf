class RemoveNameFromGrants < ActiveRecord::Migration
  def up
    remove_column :grants, :name
  end

  def down
    add_column :grants, :name, :string
  end
end
