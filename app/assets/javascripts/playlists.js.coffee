widget = null
current_track = null
current_playlist = null
inprogress = null
pausedPosition = null
embedTrackToEdit = (url, div) ->
  SC.oEmbed(
        url, 
       {auto_play: false
           , color: "FFFFEC"
           , theme_color: "14575C"
           , maxwidth: 1000
           , maxheight: 200
           , enable_api: true
           , iframe: true
           , buying: false
           , download: false
           , show_playcount: false
           , sharing: false
           , show_artwork: false
           }, 
        div
      )
AddNewTrack = (data) ->
  url = data.url
  html =  "
    <tr class='buttons'>
      <td><a href='/tracks/#{data.id}/edit' class='edit_track_button' %>Edit</td>
      <td><a href='/tracks/#{data.id}', track, method: 'delete', data: { confirm: 'Are you sure?' }, class='edit_track_button'>Delete</td>
      <td><a href='/pins/new', class='edit_track_button'>Pin</td>
    </tr>
    <tr>
      <td class='x'>
        <div class='players-holder'>  
           <div data-pins='#{[]}' data-id='#{data.id}' class='player edit' data-url='#{data.url}' id='track-holder-#{data.id}' data-duration='#{data.duration}'></div>
        </div> 
      </td>
    </tr>"

  $(".table_tracks_for_edit").prepend(html)
  div = document.getElementById("track-holder-#{data.id}")
  embedTrackToEdit(url, div) 

addWidgets = ->

  $(".player").each (i, track) ->
    url = $(@).data("url")
    track_id = $(@).data("id")
    pins = $(@).data("pins")
    if $('.player').hasClass('edit')
      div = document.getElementById("track-holder-#{track_id}")
      embedTrackToEdit(url, div )

    else
      $(pins).each (i, pin) ->
        SC.oEmbed(
          url, 
          {auto_play: false
           , color: "FFFFEC"
           , theme_color: "14575C"
           , maxwidth: 1100
           , maxheight: 300
           , enable_api: true
           , iframe: true
           , buying: false
           , download: false
           , show_playcount: false
           , sharing: false
           , show_artwork: false
           }, 
          document.getElementById("track-holder-#{track_id}-#{i}")
        )
        setTimeout( ->
          player_div = document.getElementById("track-holder-#{track_id}-#{i}")
          player_iframe = player_div.getElementsByTagName("iframe")[0]

          widget = SC.Widget(player_iframe)

          widget.bind(SC.Widget.Events.LOAD_PROGRESS, (e)->
            if (e.loadedProgress && e.loadedProgress == 1) 
              widget.seekTo(pin[0]) 
              widget.unbind(SC.Widget.Events.LOAD_PROGRESS)
          )
          widget.bind(SC.Widget.Events.PLAY_PROGRESS, (e)->
            if (e.currentPosition > pin[1])
              widget.pause()
          )
        , 10000)

currentTrack = (track, playlist) ->
  current_track = track
  current_playlist = playlist

playTrack = (playlist)->
  console.log("playPlaylist entred and in progress is", inprogress)
  track = playlist.shift()
  div_tag = $(track).attr("id")
  start_pin = $(track).data("start")
  stop_pin = $(track).data("stop")
  duration = $(track).data("duration")
  currentTrack(track, playlist)
  player_div = document.getElementById(div_tag)
  $(".active-player").animate({scrollTop: $(player_div).offset().top - $(".active-player").offset().top + $(".active-player").scrollTop()}, 1000)
  player_iframe = player_div.getElementsByTagName("iframe")[0]
  widget = SC.Widget(player_iframe)
  widget.play()
  widget.bind(SC.Widget.Events.PAUSE, -> 
    widget.seekTo(start_pin) 
    widget.bind(SC.Widget.Events.PLAY_PROGRESS, (e)->
          if (e.currentPosition > stop_pin)
            widget.pause()
        )
    playTrack(playlist) if playlist.length >0 && inprogress != 1
    )
  
  widget.bind(SC.Widget.Events.FINISH, -> 
    widget.seekTo(start_pin) 
    widget.bind(SC.Widget.Events.PLAY_PROGRESS, (e)->
          if (e.currentPosition > stop_pin)
            widget.pause()
        )
    playTrack(playlist) if playlist.length >0
    )

continuePlaylist =  ->
  alert(pausedPosition)
  start_pin = $(current_track).data("start")
  stop_pin = $(current_track).data("stop")
  div_tag = $(current_track).attr("id")
  player_div = document.getElementById(div_tag)
  player_iframe = player_div.getElementsByTagName("iframe")[0]
  widget = SC.Widget(player_iframe)
  widget.seekTo(pausedPosition)
  widget.play()
  widget.bind(SC.Widget.Events.PAUSE, -> 
    widget.seekTo(start_pin) 
    widget.bind(SC.Widget.Events.PLAY_PROGRESS, (e)->
          if (e.currentPosition > stop_pin)
            widget.pause()
        )
    inprogress = 0
    playTrack(current_playlist) if current_playlist.length >0 
    )

playPlaylist = ->
  $(".play-button").addClass("pause-button").removeClass("play-button").html("||")
  if inprogress == 1
    continuePlaylist()
  else
    playlist = $(".player").toArray()
    console.log ("sending this play list to playTrack")
    console.log(playlist)
    playTrack(playlist) 



pausePlaylist = -> 
  alert "yoooo made it to pausePlaylist"
  $(".pause-button").addClass("play-button").removeClass("pause-button").html("&#9658;")
  inprogress = 1
  console.log("pausePlaylist entred and in progress is", inprogress)
  console.log current_track
  console.log current_playlist
  div_tag = $(current_track).attr("id")
  player_div = document.getElementById(div_tag)
  player_iframe = player_div.getElementsByTagName("iframe")[0]
  widget = SC.Widget(player_iframe)
  widget.getPosition((position)->
    console.log(position)
    pausedPosition = position
    )
  widget.pause()

addPins = (pins)->
  $(pins).each (i, pin) ->
    console.log("this is the pin", pin)
    track = $(@).data("track")
    pin = $(@).data("pin")
    start = $(@).data("start")
    stop = $(@).data("stop")
    duration = $(@).data("duration")
    target_pin = "#pin-"+track+"-"+pin
    $(target_pin).slider({
      range: true,
      min: 0,
      max: duration,
      values: [ start, stop],
      slide: ( event, ui ) ->
        $("#play_range_start-#{track}-#{pin}").html(ui.values[ 0 ] )
        $("#play_range_stop-#{track}-#{pin}").html(ui.values[ 1] ) 
    })
    $("#play_range_start-#{track}-#{pin}").html(msToTime($(target_pin).slider( "values", 0 )))
    $("#play_range_stop-#{track}-#{pin}").html(msToTime($(target_pin).slider( "values", 1)))

addTrackToPlaylist =  ->
  url = $(".new_track").val()
  playlist_id = $(this).data("id")
  $.ajax "/tracks",
    type: 'POST'
    data: {track: {url: url, playlist_id:playlist_id}}
    dataType: 'json'
    success: (data, textStatus, jqXHR) ->
      console.log(data)
      AddNewTrack(data)

editPins = (e) ->
  e.preventDefault()
  track_id= $(this).data("id")
  div = ".pins_for_edit_container#pins-#{track_id}"
  $(div).show()

updatePins = (e) ->
  track_id = $(this).data("track")
  pin_id = $(this).data("pin")
  startpin =  $("#play_range_start-#{track_id}-#{pin_id}").html()
  stoppin = $("#play_range_stop-#{track_id}-#{pin_id}").html()
  $.ajax "/pins/#{pin_id}",
    type: 'PUT'
    data: {pin:{id: pin_id, track_id: track_id, startpin:startpin, stoppin: stoppin}}
    dataType: 'json'
    success: (data, textStatus, jqXHR) ->
      console.log "yessss"
      console.log data

newPin = (e) -> 
  e.preventDefault()
  track_id = $(this).data("id")
  $("#add_pin_to_track-#{track_id}").show()

getWidget = (track_id) ->
  player_div = document.getElementById("track-holder-#{track_id}")
  player_iframe = player_div.getElementsByTagName("iframe")[0]
  widget = SC.Widget(player_iframe)
  return widget


startPin = (e) ->
  track_id = $(this).data("track")
  widget = getWidget(track_id)
  widget.getPosition((position) ->
    $("#play_range_start-#{track_id}").html(msToTime(position)).attr("data-val",position)
    inprogress = 1
    $("#button_start-#{track_id}").html("STOP").addClass("stop").removeClass("start")
    )
stopPin =  ->
  track_id = $(this).data("track")
  widget = getWidget(track_id)
  widget.getPosition((position) ->
    $("#play_range_stop-#{track_id}").html(msToTime(position)).attr("data-val", position)
    inprogress = 1
    $("#button_start-#{track_id}").html("START").addClass("start").removeClass("stop")
    )

restartPin = ->
  track_id = $(this).data("track")
  $("#play_range_start-#{track_id}").html("00:00")
  $("#play_range_stop-#{track_id}").html("00:00")
  $("#button_start-#{track_id}").html("START").addClass("start").removeClass("stop")

showNewPin = (data) ->
  track_id = data.track_id
  pin_id = data.id
  startpin = data.startpin
  stoppin = data.stoppin
  duration = data.track_duration
  html = "<tr class='pins_for_edit_container' data-track='#{track_id}' data-pin='#{pin_id}' id='pins-#{track_id}'>
      <td>
      <div class='pins' data-track='#{track_id}', data-pin='#{pin_id}' id='pin-#{track_id}-#{pin_id}' data-start='#{startpin}' data-stop='#{stoppin}' data-duration='#{duration}'></div>    
      <div class='play_range start' id='play_range_start-#{track_id}-#{pin_id}' ></div>
      <div class='play_range stop' id='play_range_stop-#{track_id}-#{pin_id}' ></div>
      <div class='update' data-track='#{track_id}' data-pin='#{pin_id}'>UPDATE</div>
      <div class='update' id='delete-pin' data-track='#{track_id}' data-pin='#{pin_id}'>DELETE</div>

       </td>
    </tr>"
  $(".tracks_for_edit[data-track='#{track_id}']").after(html)
  addPins(".pins[data-track='#{track_id}'][data-pin='#{pin_id}']")

savePin = -> 
  track_id = $(this).data("track")
  startpin = $("#play_range_start-#{track_id}").data("val")
  stoppin = $("#play_range_stop-#{track_id}").data("val")
  $.ajax "/pins",
    type: "POST"
    data: {pin:{track_id:track_id, startpin:startpin, stoppin:stoppin}}
    dataType: 'json'
    success: (data, textStatus, jqXHR) ->
      showNewPin(data)

deletePin = ->
  id = $(this).data("pin")
  track = $(this).data("track")
  $.ajax "/pins/#{id}",
    type: "DELETE"
    data: {id: id}
    dataType: 'json'
    success: (data, textStatus, jqXHR) ->
      $(".pins_for_edit_container[data-track='#{track}'][data-pin='#{id}']").remove()

deleteTrack = (e) ->
  e.preventDefault()
  id = $(this).data("id")
  $.ajax "/tracks/#{id}",
    type: "DELETE"
    data: {id: id}
    dataType: 'json'
    success: (data, textStatus, jqXHR) ->
      console.log "deleted this fucking track"
      $(".tracks_for_edit[data-track='#{id}']").remove()

saveNewPlaylist = ->
 alert("yooooo") 
 console.log("hereher")
 playlist_name = $(".new-playlist-name").val()
 $.ajax "/playlists",
  type: "POST"
  data: {playlist: {playlist_name:playlist_name}}
  dataType: 'json'
  success: (data, textStatus, jqXHR) ->
    console.log data
    $(".new-playlist-form").hide()
    $(".new-playlist-name").val(" enter new playlist name")
    window.location.href = "/playlists/#{data.id}/tracks" 

showNewPlaylistForm = ->
  $(".new-playlist-form").show()
   
$ ->
  $(document).on "click", ".play-button", playPlaylist
  $('.flash').delay(4000).slideUp()
  $(document).on "click", "#new_track_button", addTrackToPlaylist
  $(".pins_for_edit_container").hide()
  $(".add_pin_to_track").hide()
  $(document).on "click", ".new-pin-track", newPin
  $(document).on "click", ".edit-track", editPins
  $(document).on "click", ".update", updatePins
  $(document).on "click", ".start", startPin
  $(document).on "click", ".stop", stopPin
  $(document).on "click", ".restart", restartPin
  $(document).on "click", ".save", savePin
  $(document).on "click", "#delete-pin", deletePin
  $(document).on "click", ".pause-button", pausePlaylist
  $('.buttons').delay(3000).fadeIn()
  $(document).on "click", "#delete-track", deleteTrack
  $(document).on "click", ".interim-play-button", continuePlaylist
  $(document).on "click", ".user-playlist.new", showNewPlaylistForm
  $(document).on "click", ".save-playlist-btn", saveNewPlaylist
  

$(window).load -> 
    addWidgets()
    addPins($(".pins"))