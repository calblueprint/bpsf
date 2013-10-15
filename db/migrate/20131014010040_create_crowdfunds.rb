class CreateCrowdfunds < ActiveRecord::Migration
  def change
    create_table :crowdfunds do |t|
      t.decimal :goal
      t.decimal :pledged_total
      t.datetime :deadline

      t.timestamps
    end
  end
end
