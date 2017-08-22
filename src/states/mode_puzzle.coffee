class controller
  constructor:->
    @playfield = new Component.Playfield(1)
  create:=>
    game.stage.backgroundColor = 0xFFFFFF
    @playfield.create @,
      push  : false
      x     : 40
      y     : 8
      panels: _d.puzzles.test

    @playfield.create_after()
  update:=>
    @playfield.update()
    @playfield.render()
  stage_music:(state)=>

ctrl = new controller()
_states.mode_puzzle =
  create: ctrl.create
  update: ctrl.update
