class AddInfoFieldsToGrants < ActiveRecord::Migration
  def change
    add_column :grants, :title, :text
    add_column :grants, :summary, :text
    add_column :grants, :subject_areas, :text
    add_column :grants, :grade_level, :text
    add_column :grants, :duration, :text
    add_column :grants, :num_classes, :integer
    add_column :grants, :num_students, :integer
    add_column :grants, :total_budget, :integer
    add_column :grants, :requested_funds, :integer
    add_column :grants, :funds_will_pay_for, :text
    add_column :grants, :budget_desc, :text
    add_column :grants, :purpose, :text
    add_column :grants, :methods, :text
    add_column :grants, :background, :text
    add_column :grants, :n_collaborators, :integer
    add_column :grants, :collaborators, :text
    add_column :grants, :comments, :text
  end
end
