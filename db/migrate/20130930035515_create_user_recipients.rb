class CreateUserRecipients < ActiveRecord::Migration
  def change
    create_table :user_recipients do |t|

      t.timestamps
    end
  end
end
