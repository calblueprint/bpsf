class AddDeadlineToGrant < ActiveRecord::Migration
  def change
    add_column :grants, :deadline, :date
  end
end
