class controller
  preload: ->
  create:=>
    @loader = game.add.text game.world.centerX, game.world.centerY, "Loading #{0}%",
      font: '30px Verdana'
      fill: '#FFF'
      align: 'center'
    @loader.scale.setTo _rez.scale
    @loader.anchor.setTo 0.5

    @files = game.add.text game.world.centerX, game.world.centerY+rs(40), "Files 0 / 0",
      font: '20px Verdana'
      fill: '#FFF'
      align: 'center'
    @files.scale.setTo _rez.scale
    @files.anchor.setTo 0.5

    @file = game.add.text game.world.centerX, game.world.centerY+rs(70), "",
      font: '20px Verdana'
      fill: '#FFF'
      align: 'center'
    @file.scale.setTo _rez.scale
    @file.anchor.setTo 0.5

    game.load.onLoadStart.add    @load_start   , @
    game.load.onFileComplete.add @file_complete, @
    game.load.onLoadComplete.add @load_complete, @
    @load()
  load_start:=>
    console.log 'start loading'
  file_complete:(progress,key,success,cur,total)=>
    @files.setText "Files #{cur} / #{total}"
    @file.setText key
  load_complete:=>
    console.log 'done loading'
    game.state.start 'load'
  update:=>
    @loader.setText "Loading #{game.load.progress}%"
  load:=>
    #game.load.audio 'sizzle'   , './sizzle.mp3'
    #game.load.image 'splash', './splash.png'
    #game.load.image 'titlescreen', './titlescreen.jpg'
    game.load.spritesheet 'cursor', './cursor.png'  , 38, 22, 2
    game.load.spritesheet 'panels', './panels.png'  , 16, 16, 136

    game.load.start()
ctrl = new controller()
_states.boot =
  create: ctrl.create
  update: ctrl.update
