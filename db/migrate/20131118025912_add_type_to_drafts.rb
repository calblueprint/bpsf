class AddTypeToDrafts < ActiveRecord::Migration
  def change
    add_column :draft_grants, :type, :string
  end
end
