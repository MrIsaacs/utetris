class window.Component.PlayfieldCountdown
  create:(@playfield)=>
    @counter = 0
    @state   = 'moving'
    x = @playfield.x+16
    y = -38
    @sprite = game.add.sprite x, y, 'playfield_countdown', 0

  update:=>
    if @state is 'moving'
      if @sprite.y < 80
        @sprite.y += 4
      else
        @state = 3
        @playfield.cursor.entrance()
    if @state is 3
      @counter++
      if @counter > 60
        @sprite.frame = 1
        @counter = 0
        @state = 2
    if @state is 2
      @counter++
      if @counter > 60
        @sprite.frame = 2
        @counter = 0
        @state = 1
    if @state is 1
      @counter++
      if @counter > 60
        @sprite.visible         = false
        @playfield.cursor.state = 'active'
        @playfield.cursor.sprite.visible = true
        @playfield.running = true
        @playfield.stage.msx_stage.play()
        @state = null
