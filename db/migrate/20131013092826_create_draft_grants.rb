class CreateDraftGrants < ActiveRecord::Migration
  def change
    create_table :draft_grants do |t|
      t.integer :recipient_id
      t.text    :title
      t.text    :summary
      t.text    :subject_areas
      t.text    :grade_level
      t.text    :duration
      t.integer :num_classes
      t.integer :num_students
      t.integer :total_budget
      t.integer :requested_funds
      t.text    :funds_will_pay_for
      t.text    :budget_desc
      t.text    :purpose
      t.text    :methods
      t.text    :background
      t.integer :n_collaborators
      t.text    :collaborators
      t.text    :comments

      t.timestamps
    end
  end
end
