class AddCropToGrants < ActiveRecord::Migration
  def change
    add_column :grants, :crop_x, :string
    add_column :grants, :crop_y, :string
    add_column :grants, :crop_w, :string
    add_column :grants, :crop_h, :string
  end
end
