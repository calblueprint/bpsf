class AddStateToUserProfile < ActiveRecord::Migration
  def change
    add_column :user_profiles, :state, :string
  end
end
