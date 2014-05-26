class RemoveRates < ActiveRecord::Migration
  def change
    drop_table :rates
  end
end
