# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $('#word_count_opt' ).change ->
    url = '/sources/data/' + $('#source_id').val() + '/' + $(this).val()
    d3.json url, (d) ->
      console.log "here!"
      console.log d
      svg = d3.select( '#word_count' )
      width = +svg.attr( 'width' )
      height = +svg.attr( 'height' )
      format = d3.format( ',d' )
      color = d3.scaleOrdinal( d3.schemeCategory20c )
      pack = d3.pack( ).size( [
        width
        height
      ]).padding( 1.5 )
      return false
    
    
