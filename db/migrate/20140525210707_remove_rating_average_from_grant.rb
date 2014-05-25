class RemoveRatingAverageFromGrant < ActiveRecord::Migration
  def change
    remove_column :grants, :rating_average
  end
end
