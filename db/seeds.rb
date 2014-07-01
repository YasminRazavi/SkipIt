# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

user1 = User.new(:first_name => "yasmin", :last_name => "razavi", :email => "yasmin.razavi@gmail.com", :password => "password")
user2 = User.new(:first_name => "jens", :last_name => "peters", :email => "jens@gmail.com", :password => "password")

[user1, user2].each(&:skip_confirmation!).each(&:save!)

playlist1 = Playlist.create(:user_id =>1, :playlist_name => "party party")
playlist2 = Playlist.create(:user_id =>1, :playlist_name => "chill out time")
playlist3 = Playlist.create(:user_id =>2, :playlist_name => "RAVE")

track1 = Track.create(:user_id =>1, :playlist_id => 1, :url => "https://soundcloud.com/maeverecords/matthew-dekay-patience-please-snippet", :artist => "matt dekay", :name => "new shit")

track2 = Track.create(:user_id =>1, :playlist_id => 1, :url => "https://soundcloud.com/scissorandthread/what-you-believe-clip", :artist => "toy and scissor", :name => "melody")

track3 = Track.create(:user_id =>2, :playlist_id => 3, :url => "https://soundcloud.com/ritter-butzke/daniel-solar-ritter-butzke", :artist => "daniel solar", :name => "Ritte Butzke Mix")
track4 = Track.create(:user_id =>2, :playlist_id => 3, :url => "https://soundcloud.com/danielbrandt/baby-i-got-your-money-brando", :artist => "BBF", :name => "Baby I got you")


pin1 = Pin.create(:track_id => 1, :startpin => 120000, :stoppin => 130000)

pin2 = Pin.create(:track_id => 2, :startpin => 120000, :stoppin => 130000)
pin3 = Pin.create(:track_id => 3, :startpin => 120000, :stoppin => 130000)
pin4 = Pin.create(:track_id => 4, :startpin => 120000, :stoppin => 130000)
