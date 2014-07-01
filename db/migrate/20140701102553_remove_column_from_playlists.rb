class RemoveColumnFromPlaylists < ActiveRecord::Migration
  def up
    remove_column :playlists, :track_id
  end

  def down
    add_column :playlists, :track_id, :string
  end
end
