addWidgets = ->

  $(".player").each (i, track) ->
    console.log i
    url = $(@).data("url")
    track_id = $(@).data("id")
    pins = $(@).data("pins")
    console.log("start pin", pins[0][0])
    console.log("sop pin", pins[0][1])

    if $('.player').hasClass('edit')
      SC.oEmbed(
        url, 
        {auto_play: false
         , color: "915f33"
         , maxwidth: 1000
         , maxheight: 200
         , enable_api: true
         , iframe: true
         }, 
        document.getElementById("track-holder-#{track_id}")
      )
      # player_div = document.getElementById("track-holder-#{track_id}")
      # player_iframe = player_div.getElementsByTagName("iframe")[0]
      # setTimeout( ->
      #   widget = SC.Widget(player_iframe)
      #   widget.getDuration((duration)->
      #     console.log("duratio",duration)
      #     $(player_div).data("duration",duration)
      #   )
      # , 20000)
    else
      $(pins).each (i, pin) ->
        SC.oEmbed(
          url, 
          {auto_play: false
           , color: "915f33"
           , maxwidth: 1000
           , maxheight: 200
           , enable_api: true
           , iframe: true
           }, 
          document.getElementById("track-holder-#{track_id}-#{i}")
        )
        setTimeout( ->
          player_div = document.getElementById("track-holder-#{track_id}-#{i}")
          player_iframe = player_div.getElementsByTagName("iframe")[0]
          console.log("player_iframe", player_iframe)

          widget = SC.Widget(player_iframe)

          widget.getDuration((duration)->
            $(player_div).data("duration",duration)
            )

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
  # widget.setVolume(0)
  # widget.setVolume(100)
  widget.bind(SC.Widget.Events.PAUSE, -> 
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
    console.log(pin, i)
    track = $(@).data("track")
    console.log("track", track)
    pin = $(@).data("pin")
    console.log("pin", pin)
    start = $(@).data("start")
    console.log("start", start)
    stop = $(@).data("stop")
    console.log("stop", stop)
    target_pin = "#pin-"+track+"-"+pin
    console.log("target pin", target_pin)
    $(target_pin).slider({
      range: true,
      min: 0,
      max: 100,
      values: [ 20, 50],
      slide: ( event, ui ) ->
        $("#play_range").val( "$" + ui.values[ 0 ] + " - $" + ui.values[ 1 ] );
      
    })
    # $("#play_range").val( "$" + $(pin ).slider( "values", 0 ) +
    #   " - $" + $(pin ).slider( "values", 1 ) );
    


   
$ ->
  $(document).on "click", ".play-button", playPlaylist
  # if !!$(".player").length 
  #   $(".player")[0].scrollTo( $('.actie-player'))

$(window).load -> 
    addWidgets()
    addPins()