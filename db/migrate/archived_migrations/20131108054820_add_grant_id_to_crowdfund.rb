class AddGrantIdToCrowdfund < ActiveRecord::Migration
  def change
    add_column :crowdfunds, :grant_id, :integer
  end
end
