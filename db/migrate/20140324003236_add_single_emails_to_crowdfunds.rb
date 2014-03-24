class AddSingleEmailsToCrowdfunds < ActiveRecord::Migration
  def change
    add_column :crowdfunds, :eighty, :boolean
    add_column :crowdfunds, :finished, :boolean
  end
end
