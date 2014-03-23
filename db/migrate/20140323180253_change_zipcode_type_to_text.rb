class ChangeZipcodeTypeToText < ActiveRecord::Migration
  def up
    change_column :user_profiles, :zipcode, :text
    change_column :recipient_profiles, :zipcode, :text
  end

  def down
    change_column :user_profiles, :zipcode, :integer
    change_column :recipient_profiles, :zipcode, :integer
  end
end
