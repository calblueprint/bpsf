class RemoveDistrictFromSchools < ActiveRecord::Migration
  def up
    remove_column :schools, :district
  end

  def down
    add_column :schools, :district, :string
  end
end
