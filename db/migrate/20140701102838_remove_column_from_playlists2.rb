class RemoveColumnFromPlaylists2 < ActiveRecord::Migration
  def up
    remove_column :playlists, :Name
  end

  def down
    add_column :playlists, :Name, :string
  end
end
