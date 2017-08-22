class window.Component.PlayfieldCountdown
  create:(@playfield)=>
    @sfx_blip  = game.add.audio 'sfx_countdown_blip'
    @sfx_ding  = game.add.audio 'sfx_countdown_ding'

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
        @sprite.frame = 1
        @state = 3
        @playfield.cursor.entrance()
        @sfx_blip.play()
    if @state is 3
      @counter++
      if @counter > 60
        @sfx_blip.play()
        @sprite.frame = 2
        @counter = 0
        @state = 2
    if @state is 2
      @counter++
      if @counter > 60
        @sfx_blip.play()
        @sprite.frame = 3
        @counter = 0
        @state = 1
    if @state is 1
      @counter++
      if @counter > 60
        @sfx_ding.play()
        @sprite.visible         = false
        @playfield.cursor.state = 'active'
        @playfield.cursor.sprite.visible = true
        @playfield.running = true
        @playfield.stage.stage_music 'active'
        @state = null
