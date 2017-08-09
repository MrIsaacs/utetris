class controller
  constructor:->
    @playfield1 = new Component.Playfield()
    @playfield2 = new Component.Playfield()
  create_bg:(scale)=>
    @bg = game.add.sprite -(scale*18),0, 'vs_bg'
    @bg.smoothed = false
    @bg.scale.setTo scale
  create_frame:(scale,x)=>
    @frame = game.add.sprite x,0, 'vs_frame'
    @frame.smoothed = false
    @frame.scale.setTo scale
  create:=>
    game.stage.backgroundColor = 0x000000
    unit  = (game.stage.height / (WIN_HEIGHT/WIN_UNIT))
    scale = unit / WIN_UNIT

    #x offset
    x = (game.stage.width / 2) - ((scale * WIN_WIDTH) /2)

    @create_bg scale

    @playfield1.create
      push : true
      scale: scale
      unit : unit
      x: (scale * 8) + x
      y: scale * 8

    @playfield2.create
      push : true
      scale: scale
      unit : unit
      x: (scale * 152) + x
      y: scale * 8

    @create_frame scale, x

  update:=>
    @playfield1.tick()
    @playfield2.tick()

    @playfield1.render()
    @playfield2.render()
ctrl = new controller()
_states.mode_1p_vs_cpu =
  create: ctrl.create
  update: ctrl.update
