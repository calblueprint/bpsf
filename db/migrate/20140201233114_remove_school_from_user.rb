class RemoveSchoolFromUser < ActiveRecord::Migration
  def up
    remove_column :users, :school_id
  end

  def down
    add_column :users, :school_id, :integer
  end
end
