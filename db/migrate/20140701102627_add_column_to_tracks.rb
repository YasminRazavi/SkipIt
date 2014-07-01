class AddColumnToTracks < ActiveRecord::Migration
  def change
    add_column :tracks, :artist, :string
    add_column :tracks, :name, :string
  end
end
