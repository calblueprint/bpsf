class CreateGrants < ActiveRecord::Migration
  def change
    create_table :grants do |t|
      t.string :name
      t.string :organization
      t.integer :sum

      t.timestamps
    end
  end
end
