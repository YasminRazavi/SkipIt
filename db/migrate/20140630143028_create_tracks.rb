class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.integer :user_id
      t.integer :playlist_id
      t.string :url
      t.integer :sc_id

      t.timestamps
    end
  end
end
