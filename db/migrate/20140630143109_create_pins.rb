class CreatePins < ActiveRecord::Migration
  def change
    create_table :pins do |t|
      t.integer :track_id
      t.integer :startpin
      t.integer :stoppin

      t.timestamps
    end
  end
end
