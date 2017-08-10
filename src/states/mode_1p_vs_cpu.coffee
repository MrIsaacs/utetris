class controller
  constructor:->
    @playfield1 = new Component.Playfield()
    @playfield2 = new Component.Playfield()
  create_bg:=>
    @bg = game.add.sprite 0,0, 'vs_bg'
  create_frame:(offset)=>
    @frame = game.add.sprite offset,0, 'vs_frame'
  create:=>
    game.stage.backgroundColor = 0x000000

    offset = 89
    @create_bg()
    @playfield1.create push: true, x: offset+8  , y: 8
    @playfield2.create push: true, x: offset+152, y: 8
    @create_frame(offset)

  update:=>
    @playfield1.tick()
    @playfield2.tick()

    @playfield1.render()
    @playfield2.render()
ctrl = new controller()
_states.mode_1p_vs_cpu =
  create: ctrl.create
  update: ctrl.update
