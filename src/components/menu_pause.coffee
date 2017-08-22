class window.Component.MenuPause
  constructor:->
    @cursor = new Component.MenuPauseCursor()
  create:(@playfield)=>
    @paused = false
    @sprite = game.add.sprite @playfield.x+4, 100, 'menu_pause'
    @sprite.visible = false
    @cursor.create @, 8, 8, [
      @contiune
      @cancel
    ]
  cancel:=>
    @paused = false
    game.state.start 'menu'
  contiune:=>
    @paused         = false
    @sprite.visible = false
    @playfield.stage.resume(@playfield.pi)
  pause:(pi)=>
    @paused         = true
    if @playfield.pi is pi
      @sprite.visible = true
      @cursor.map_controls()
    else
      _d.controls.map @playfield.pi, {} #disable controls
  update:=>
    return unless @paused
    @cursor.update()
