class RemoveSumFromGrants < ActiveRecord::Migration
  def up
    remove_column :grants, :sum
  end

  def down
    add_column :grants, :sum, :integer
  end
end
