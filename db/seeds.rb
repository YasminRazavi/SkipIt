

user1 = User.new(:first_name => "yasmin", :last_name => "razavi", :email => "yasmin.razavi2@gmail.com", :password => "password")
user2 = User.new(:first_name => "jens", :last_name => "peters", :email => "jens2@gmail.com", :password => "password")

[user1, user2].each(&:skip_confirmation!).each(&:save!)

playlist1 = Playlist.create(:user_id =>1, :playlist_name => "party party")
playlist2 = Playlist.create(:user_id =>1, :playlist_name => "chill out time")
playlist3 = Playlist.create(:user_id =>2, :playlist_name => "RAVE")

track1 = Track.create(:user_id =>1, :playlist_id => 1, :url => "https://soundcloud.com/maeverecords/matthew-dekay-patience-please-snippet", :artist => "matt dekay", :name => "new shit", :duration => 153600)

track2 = Track.create(:user_id =>1, :playlist_id => 1, :url => "https://soundcloud.com/scissorandthread/what-you-believe-clip", :artist => "toy and scissor", :name => "melody", :duration => 152400)

track3 = Track.create(:user_id =>2, :playlist_id => 3, :url => "https://soundcloud.com/ritter-butzke/daniel-solar-ritter-butzke", :artist => "daniel solar", :name => "Ritte Butzke Mix", :duration => 3600000)
track4 = Track.create(:user_id =>2, :playlist_id => 3, :url => "https://soundcloud.com/danielbrandt/baby-i-got-your-money-brando", :artist => "BBF", :name => "Baby I got you", :duration => 360000)


pin1 = Pin.create(:track_id => 1, :startpin => 120000, :stoppin => 130000)

pin2 = Pin.create(:track_id => 2, :startpin => 120000, :stoppin => 130000)
pin3 = Pin.create(:track_id => 3, :startpin => 120000, :stoppin => 130000)
pin4 = Pin.create(:track_id => 4, :startpin => 120000, :stoppin => 130000)
pin5 = Pin.create(:track_id => 1, :startpin => 140000, :stoppin => 145000)
pin6 = Pin.create(:track_id => 2, :startpin => 150000, :stoppin => 155000)
