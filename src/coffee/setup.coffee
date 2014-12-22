$ = require 'jquery'
$ -> 
  console.log 'Jquery ready'

  randomColor = ->
    colors = [
      '#d09cdd', # violet
      '#f0a748', # orange
      '#6ab5b1', # aqua
      '#cd251f', # red
      '#78595e', # dark purple
      '#51b355', # green
    ]

    $('.countBox').css({
      'background-color': colors[Math.floor(Math.random() * colors.length)]
    });

  randomEames = ->
    colors = [
      '#76A2B1', # aqua
      '#AD573D', # sienna
      '#DBD294', # ochre
      '#E5514C', # salmon
      '#B7C559', # lime
    ]

    $('.countBox').css({
      'background-color': colors[Math.floor(Math.random() * colors.length)]
    });




  # randomColor();
  randomEames();



