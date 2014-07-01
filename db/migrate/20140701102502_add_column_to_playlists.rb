class AddColumnToPlaylists < ActiveRecord::Migration
  def change
    add_column :playlists, :Name, :string
  end
end
