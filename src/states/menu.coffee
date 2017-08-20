class controller
  constructor:->
    @menu = new Component.Menu()
  create:=>
    game.stage.backgroundColor = '#ffffff'

    @bg = game.add.tileSprite 0, 0, game.world.width, game.world.height, 'bg_blue'
    @menu.create()

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
  update:=>
    @menu.update()
    @bg.tilePosition.y += 0.5
    @bg.tilePosition.x -= 0.5

ctrl = new controller()

_states.menu =
  create: ctrl.create
  update: ctrl.update
