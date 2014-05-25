class RemoveRatingFromGrant < ActiveRecord::Migration
  def up
    remove_column :grants, :rating_average
  end

  def down
    add_column :grants, :rating_average, :decimal
  end
end
