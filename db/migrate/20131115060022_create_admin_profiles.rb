class CreateAdminProfiles < ActiveRecord::Migration
  def change
    create_table :admin_profiles do |t|
      t.string :about
      t.string :position

      t.timestamps
    end
  end
end
