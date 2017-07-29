class controller
  constructor:->
    @playfield = new Component.Playfield()
  create:=>
    game.stage.backgroundColor = 0xFFFFFF
    @playfield.create 6, 12, NRBLOCK
  update:=>
    @playfield.tick()
    @playfield.render()

ctrl = new controller()
_states.single_player =
  create: ctrl.create
  update: ctrl.update
