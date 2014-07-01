# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


addWidgets = ->

  $(".player").each (track, i) ->
    url = $(@).data("url")
    track_id = $(@).data("id")
    pins = $(@).data("pins")
    SC.oEmbed(
      url, 
      {auto_play: false}, 
      document.getElementById("track-holder-#{track_id}")
    );











$(window).load -> 
    addWidgets()