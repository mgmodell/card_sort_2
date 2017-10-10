# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#Building a D3 Force-Directed Chart
$(document).ready ->
  $('#relate_opt' ).change ->
    url = '/' + $('#granularity').val() + '/relate_data/' 
    url = url + $('#source_id').val() + '/' + $('#relate_opt').val() + '.json'
    svg = d3.select( '#relationships' )
    width = +svg.attr( 'width' )
    height = +svg.attr( 'height' )

    simulation = d3.forceSimulation( )
      .force( "link", d3.forceLink().id( (d)-> 
        return d.id; ))
      .force( "charge", d3.forceManyBody() )
      .force( "center", d3.forceCenter( width / 2, height / 2 ) )

    d3.json url, (graph) ->
      svg = d3.selectAll( '#relationships > *' ).remove()
      link = svg.append( "g" )
        .attr("class", "links")
        .selectAll( "line" )
        .data( graph.links )
        .enter.append( "line" )
          .attr("stroke-width", (d)-> 
            return Math.sqrt(d.value);
          )

      node = svg.append( "g" )
        .attr("class", "nodes")
        .selectAll( "circle" )
        .data( graph.nodes )
        .enter.append( "circle" )
          .attr( "r", 5 )
          .call( d3.drag()
            .on( "start", dragstarted )
            .on( "drag", dragged )
            .on( "end", dragended )

      node.append( "title" )
        .text( $( '#relate_opt' ) )

      simulation
        .nodes(graph.nodes)
        .on("tick", ticked);

      simulation.force("link")
        .links(graph.links);

      ticked = -> 
        link
          .attr("x1", (d)-> 
            return d.source.x
          )
          .attr("y1", (d) ->
            return d.source.y
          )
          .attr("x2", (d) ->
            return d.target.x
          )
          .attr("y2", (d) ->
            return d.target.y
          )
        node
          attr("cx", (d) ->
            return d.x
          )
          attr("cy", (d) ->
            return d.y
          )

dragstarted = (d)->
  if (!d3.event.active) simulation.alphaTarget(0.3).restart()
  d.fx = d.x
  d.fy = d.y

dragged = (d) ->
  d.fx = d3.event.x
  d.fy = d3.event.y

dragended = (d)->
  if (!d3.event.active) simulation.alphaTarget(0)
  d.fx = null
  d.fy = null
