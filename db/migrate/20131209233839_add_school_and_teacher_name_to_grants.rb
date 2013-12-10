class AddSchoolAndTeacherNameToGrants < ActiveRecord::Migration
  def change
    add_column :grants, :school_name, :string
    add_column :grants, :teacher_name, :string
  end
end
