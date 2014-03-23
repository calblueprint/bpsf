class AddStatusToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :status, :text
  end
end
