class Playlist < ActiveRecord::Base
  attr_accessible :track_id, :user_id, :playlist_name
  belongs_to :user, :class_name => "User", :foreign_key => "user_id"
  has_many :tracks
end
