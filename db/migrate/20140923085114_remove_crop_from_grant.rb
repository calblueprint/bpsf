class RemoveCropFromGrant < ActiveRecord::Migration
  def up
    remove_column :grants, :crop_x
    remove_column :grants, :crop_y
    remove_column :grants, :crop_w
    remove_column :grants, :crop_h
  end

  def down
    add_column :grants, :crop_x, :string
    add_column :grants, :crop_y, :string
    add_column :grants, :crop_w, :string
    add_column :grants, :crop_h, :string
  end
end
