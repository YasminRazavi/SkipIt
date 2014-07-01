class Pin < ActiveRecord::Base
  attr_accessible :startpin, :stoppin, :track_id
  belongs_to :track, :class_name => "Track", :foreign_key => "track_id"

end
