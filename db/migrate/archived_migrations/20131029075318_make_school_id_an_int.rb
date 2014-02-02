class MakeSchoolIdAnInt < ActiveRecord::Migration
  def up
    remove_column :grants, :school_id
    add_column :grants, :school_id, :integer
    remove_column :draft_grants, :school_id
    add_column :draft_grants, :school_id, :integer
  end

  def down
    change_column :grants, :school_id, :string
    change_column :draft_grants, :school_id, :string
  end
end
