class AddPhoneNumbersToRecipientProfile < ActiveRecord::Migration
  def change
    add_column :recipient_profiles, :work_phone, :string
    add_column :recipient_profiles, :home_phone, :string
  end
end
