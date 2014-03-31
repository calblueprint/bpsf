class AddOtherToGrants < ActiveRecord::Migration
  def change
    add_column :grants, :other_funds, :text
  end
end
