class AddTimeTeachingAndSubjectAndGradeToRecipientProfile < ActiveRecord::Migration
  def change
    add_column :recipient_profiles, :started_teaching, :datetime
    add_column :recipient_profiles, :subject, :string
    add_column :recipient_profiles, :grade, :string
  end
end
