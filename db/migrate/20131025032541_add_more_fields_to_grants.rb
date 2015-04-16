class AddMoreFieldsToGrants < ActiveRecord::Migration
  def change
    # Schools
    add_column :grants, :image_url, :string
    add_column :grants, :school_id, :string

    add_column :draft_grants, :image_url, :string
    add_column :draft_grants, :school_id, :string
  end
end
