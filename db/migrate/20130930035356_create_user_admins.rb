class CreateUserAdmins < ActiveRecord::Migration
  def change
    create_table :user_admins do |t|

      t.timestamps
    end
  end
end
