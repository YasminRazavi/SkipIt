class AddColumnToPlaylists2 < ActiveRecord::Migration
  def change
    add_column :playlists, :playlist_name, :string
  end
end
