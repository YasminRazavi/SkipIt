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
  alert("yo made it to new track")
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
    console.log $(".player")
    url = $(@).data("url")
    track_id = $(@).data("id")
    pins = $(@).data("pins")
    console.log("pins", pins)
    if $('.player').hasClass('edit')
      div = document.getElementById("track-holder-#{track_id}")
      console.log("div", div)
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
          console.log("player_iframe", player_iframe)

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



playTrack = (playlist)->
  track = playlist.shift()
  div_tag = $(track).attr("id")
  start_pin = $(track).data("start")
  stop_pin = $(track).data("stop")
  duration = $(track).data("duration")
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
    playTrack(playlist) if playlist.length >0
    )
  widget.bind(SC.Widget.Events.FINISH, -> 
    widget.seekTo(start_pin) 
    widget.bind(SC.Widget.Events.PLAY_PROGRESS, (e)->
          if (e.currentPosition > stop_pin)
            widget.pause()
        )
    playTrack(playlist) if playlist.length >0
    )

          
        

playPlaylist = ->
  console.log ("entered playPlaylist")
  playlist = $(".player").toArray()
  console.log ("sending this play list to playTrack")
  console.log(playlist)
  playTrack(playlist) 

addPins = ->
  $(".pins").each (i, pin) ->
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
    $("#play_range_start-#{track}-#{pin}").html($(target_pin).slider( "values", 0 ))
    $("#play_range_stop-#{track}-#{pin}").html($(target_pin).slider( "values", 1))

addTrackToPlaylist =  ->
  console.log("adding track")
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

  
   
$ ->
  $(document).on "click", ".play-button", playPlaylist
  # if !!$(".player").length 
  #   $(".player")[0].scrollTo( $('.actie-player'))
  $(document).on "click", "#new_track_button", addTrackToPlaylist
  $(".pins_for_edit_container").hide()
  $(document).on "click", ".edit-track", editPins
  $(document).on "click", ".update", updatePins

$(window).load -> 
    addWidgets()
    addPins()