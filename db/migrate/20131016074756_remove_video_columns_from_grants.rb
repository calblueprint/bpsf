class RemoveVideoColumnsFromGrants < ActiveRecord::Migration
  def up
    remove_column :grants, :video_file_name
    remove_column :grants, :video_content_type
    remove_column :grants, :video_file_size
    remove_column :grants, :video_updated_at

    remove_column :draft_grants, :video_file_name
    remove_column :draft_grants, :video_content_type
    remove_column :draft_grants, :video_file_size
    remove_column :draft_grants, :video_updated_at
  end

  def down
    add_column :grants, :video_file_name
    add_column :grants, :video_content_type
    add_column :grants, :video_file_size
    add_column :grants, :video_updated_at

    add_column :draft_grants, :video_file_name
    add_column :draft_grants, :video_content_type
    add_column :draft_grants, :video_file_size
    add_column :draft_grants, :video_updated_at
  end
end
