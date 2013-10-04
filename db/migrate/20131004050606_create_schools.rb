class CreateSchools < ActiveRecord::Migration
  def change
    create_table :schools do |t|
      t.string :name
      t.integer :donations_received
      t.string :district

      t.timestamps
    end
  end
end
