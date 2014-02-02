class RenameImageUrlToImage < ActiveRecord::Migration
  def change
    rename_column :draft_grants, :image_url, :image
    rename_column :grants, :image_url, :image
  end
end
