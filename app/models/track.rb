class Track < ActiveRecord::Base
  attr_accessible :playlist_id, :sc_id, :url, :user_id, :artist, :name

  belongs_to :user, :class_name=> "User", :foreign_key => "user_id"
  belongs_to :playlist, :class_name=> "Playlist", :foreign_key => "playlist_id"
  has_many :pins


end
