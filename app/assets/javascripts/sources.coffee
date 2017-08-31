# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#Building a D3 Bubble Chart
$(document).ready ->
  $('#word_count_opt, #slice_opt' ).change ->
    url = '/' + $('#granularity').val() + '/data/' 
    url = url + $('#source_id').val() + '/' + $('#word_count_opt').val() 
    url = url + '/' + $('#slice_opt').val() + '.json'
    d3.json url, (d) ->
      svg = d3.selectAll( '#word_counts > *' ).remove()
      svg = d3.select( '#word_counts' )
      width = +svg.attr( 'width' )
      height = +svg.attr( 'height' )
      format = d3.format( ',d' )

      color = d3.scaleOrdinal( d3.schemeCategory20c)
      pack = d3.pack()
        .size( [width, height ] )
        .padding( 1.5 )

      root = d3.hierarchy( children: d )
        .sum( (d) ->
          d[ 1 ]
        )
        .each( (d) -> 
          d[ 0 ]
        )
            

      node = svg.selectAll( '.node' )
        .data( pack( root ).leaves() )
        .enter().append( 'g' )
        .attr( 'class', 'node' )
        .attr( 'transform', (d) ->
          'translate(' + d.x + ',' + d.y + ')';
        )
    
    
      node.append( 'circle' )
        .attr( 'id', (d) ->
          d.data[ 0 ]
        )
        .attr( 'r', (d) ->
          d.r
        )
        .style( 'fill', (d) ->
          color( d.package )
        )

      node.append( 'clipPath' )
        .attr( 'id', (d) ->
          'clip-' + d.data[ 0 ]
        )
        .append( 'use' )
        .attr( 'xlink:href', (d) ->
          '#' + d.data[ 0 ]
        )

      node.append( 'text' )
        .attr( 'clip-path', (d) ->
          'url(#clip-' + d.data[ 0 ] + ')'
        )
        .selectAll( 'tspan' )
        .data( (d) ->
          d.data[ 0 ]
        )
        .enter().append( 'tspan' )
        .attr( 'x', 0 )
        .attr( 'y', (d, i, nodes) ->
          13 + (i - nodes.length / 2 - 0.5) * 10
        )
        .text( (d) ->
          d
        )

      node.append( 'title' )
        .text( (d) ->
          d.data[ 0 ] + '\n' + format( d.data[ 1 ] )
        )

