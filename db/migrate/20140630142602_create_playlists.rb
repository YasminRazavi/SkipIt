class CreatePlaylists < ActiveRecord::Migration
  def change
    create_table :playlists do |t|
      t.integer :user_id
      t.integer :track_id

      t.timestamps
    end
  end
end
