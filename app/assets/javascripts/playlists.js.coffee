addWidgets = ->

  $(".player").each (i, track) ->
    console.log i
    url = $(@).data("url")
    track_id = $(@).data("id")
    pins = $(@).data("pins")
    console.log("start pin", pins[0][0])
    console.log("sop pin", pins[0][1])

    $(pins).each (i, pin) ->
      console.log("pins are:", pin)
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
      );
      
      setTimeout( ->
        player_div = document.getElementById("track-holder-#{track_id}-#{i}")
        player_iframe = player_div.getElementsByTagName("iframe")[0]
        widget = SC.Widget(player_iframe)
        console.log "object"
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
  console.log(div_tag)
  duration = $(track).data("duration")
  player_div = document.getElementById(div_tag)
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
    playTrack(playlist)
    )

          
        

playPlaylist = ->
  playlist = $(".player").toArray()
  playTrack(playlist) 




   
$ ->
  $(document).on "click", ".play-button", playPlaylist


$(window).load -> 
    addWidgets()