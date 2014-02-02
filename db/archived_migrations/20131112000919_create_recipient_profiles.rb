class CreateRecipientProfiles < ActiveRecord::Migration
  def change
    create_table :recipient_profiles do |t|
      t.integer :school_id
      t.string :image_url
      t.text :about

      t.timestamps
    end
  end
end
