class CreateUserProfiles < ActiveRecord::Migration
  def change
    create_table :user_profiles do |t|
      t.text :address
      t.text :phone
      t.text :relationship
      t.integer :user_id

      t.timestamps
    end

    add_index :user_profiles, :user_id
  end
end
