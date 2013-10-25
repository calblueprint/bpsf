class AddCrowdFundToPayment < ActiveRecord::Migration
  def change
    add_column :payments, :crowdfund_id, :integer
  end
end
