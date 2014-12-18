$ -> 
  console.log 'Jquery ready'

  randomBackground = ->
    images = [
      'bg2.jpg',
      'bg3.jpg',
      'bg4.jpg',
      'bg5.jpg',
      'bg6.jpg',
      'bg7.jpg',
      'bg8.jpg',
      'bg9.jpg',
      'bg10.jpg',
      'bg11.jpg',
    ];
    $('body').css({
      'background-image': 'url(static/images/bg/' + images[Math.floor(Math.random() * images.length)] + ')'
    });

  randomBackground();
  



