class controller
  constructor:->
    @playfield = new Component.Playfield()
  create:=>
    game.stage.backgroundColor = 0xFFFFFF
    @playfield.create
      push: true
  update:=>
    @playfield.tick()
    @playfield.render()

ctrl = new controller()
_states.mode_1p_vs_cpu =
  create: ctrl.create
  update: ctrl.update
