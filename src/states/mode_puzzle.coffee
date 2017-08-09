class controller
  constructor:->
    @playfield = new Component.Playfield()
  create:=>
    game.stage.backgroundColor = 0x000000

    unit  = (game.stage.height / (WIN_HEIGHT/WIN_UNIT))
    scale = unit / WIN_UNIT

    x = (game.stage.width / 2) - ((scale * WIN_WIDTH) /2)
    console.log 'puzzle', _d.puzzles.skill_chain_demo_2.demo_4
    @playfield.create
      push  : false
      scale : scale
      unit  : unit
      x     : (scale * 8) + x
      y     : scale * 8
      panels: _d.puzzles.skill_chain_demo_2.demo_4
  update:=>
    @playfield.tick()
    @playfield.render()

ctrl = new controller()
_states.mode_puzzle =
  create: ctrl.create
  update: ctrl.update
