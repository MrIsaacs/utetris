class controller
  constructor:->
    @btn_1p_vs_cpu = new Component.ButtonMenu 'mode_1p_vs_cpu'
    @btn_1p_vs_2p  = new Component.ButtonMenu 'mode_1p_vs_2p'
    @btn_puzzles   = new Component.ButtonMenu 'mode_puzzles'
  create:=>
    game.stage.backgroundColor = '#ffffff'

    @bg = game.add.tileSprite 0, 0, game.world.width, game.world.height, 'bg_blue'
    @bg.smoothed = false
    unit  = (game.stage.height / (WIN_HEIGHT/WIN_UNIT))
    scale = unit / WIN_UNIT
    @bg.tileScale.y = scale
    @bg.tileScale.x = scale


    console.log 'titlescreen'
    #@bg = game.add.sprite 0,0, 'titlescreen'
    #@bg.scale.setTo _rez.scale

    x = _rez.w/2
    y = _rez.h/2
    @btn_1p_vs_cpu.create  x+rs(40), y-rs(100) , -100, '1P VS CPU'
    @btn_1p_vs_2p.create   x+rs(40), y+rs(20)  , -100, '1P VS 2P'
    @btn_puzzles.create    x+rs(40), y+rs(140) , -100, 'Puzzles'
    @ver()
  ver:=>
    v = "#{_d.version.major}.#{_d.version.minor}.#{_d.version.patch}"
    t = "VER #{v}"
    x = 1920 - 160
    y = 1080 - 36
    build = game.add.text rs(x), rs(y), t,
      font: '18px Verdana'
      fill: '#999999'
      fontWeight: 'bold'
      align: 'center'
    build.anchor.setTo 0, 1
    build.scale.setTo _rez.scale
  update:=>
    @bg.tilePosition.y += 0.2
    @bg.tilePosition.x -= 0.2

ctrl = new controller()

_states.menu =
  create: ctrl.create
  update: ctrl.update
