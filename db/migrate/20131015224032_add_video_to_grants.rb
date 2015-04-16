class AddVideoToGrants < ActiveRecord::Migration
  def change
    add_column :grants, :video, :string
    add_column :draft_grants, :video, :string
  end
end
