class window.Component.MenuPause
  constructor:->
    @cursor = new Component.MenuPauseCursor()
  create:(@playfield)=>
    @paused = false
    @sprite = game.add.sprite 101, 100, 'menu_pause'
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
    @playfield.unpause()
  pause:=>
    @paused         = true
    @sprite.visible = true
    @cursor.map_controls()
  update:=>
    return unless @paused
    @cursor.update()
