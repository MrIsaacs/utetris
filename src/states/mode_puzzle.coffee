class controller
  constructor:->
    @playfield = new Component.Playfield()
  create:=>
    game.stage.backgroundColor = 0xFFFFFF
    @playfield.create
      ai    : false
      puzzle: window.puzzle
      push  : false
  update:=>
    @playfield.tick()
    @playfield.render()

ctrl = new controller()
_states.mode_puzzle =
  create: ctrl.create
  update: ctrl.update
