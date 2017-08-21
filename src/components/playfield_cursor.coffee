class window.Component.PlayfieldCursor
  create:(@playfield,opts={})=>
    @state      = 'hidden'
    @sfx_select = game.add.audio 'sfx_select'

    @counter_flicker = 0
    @counter         = 0
    @x = 2
    @y = 6

    # center the cursor
    @ai = opts.ai || false

    diff = (UNIT / 16) * 3
    @sprite = game.make.sprite ((COLS-2)*UNIT)-diff, 0-diff, 'playfield_cursor', 0
    @sprite.animations.add  'idle', [0,1]
    @sprite.animations.play 'idle', Math.round(game.time.desiredFps / 10), true
    @sprite.visible = false

    @playfield.layer_cursor.add @sprite
  entrance:=>
    @sprite.visible = true
    @state          = 'entering'
  map_controls:=>
    _d.controls.map @playfield.pi,
      up   : @up
      down : @down
      left : @left
      right: @right
      a    : @swap
      b    : @swap
      start: @pause
  pause:=>
    @playfield.pause()
  up:=>
    @sfx_select.play()
    @y-- if @y > 0
  down:=>
    @sfx_select.play()
    @y++ if @y < ROWS - 1
  left:=>
    @sfx_select.play()
    @x-- if @x > 0
  right:=>
    @sfx_select.play()
    @x++ if @x < COLS - 2
  swap:=>
    return unless @playfield.running && @state is 'active'
    @playfield.swap @x, @y
  can_push:=>
    (_d.controls.keys["pl#{@playfield.pi}_l"].isDown ||
    _d.controls.keys["pl#{@playfield.pi}_r"].isDown) &&
    @playfield.running &&
    @state is 'active'
  update:=>
    diff = (UNIT / 16) * 3
    y    = if @playfield.should_push then @y else @y+1
    x    = (@x * UNIT) - diff
    y    = (y * UNIT)  - diff
    
    if @state is 'entering' || @state is 'preactive'
      @counter_flicker++
      if @counter_flicker > 1
        @counter_flicker = 0
        @sprite.visible = !@sprite.visible
    switch @state
      when 'entering'
        if @sprite.y < y
          @sprite.y += STARTPOS_PANELCURSOR_SPEED
        else if @sprite.x > x
          @sprite.x -= STARTPOS_PANELCURSOR_SPEED
        else
          @state = 'preactive'
          @map_controls() if @ai is false
      when 'preactive', 'active'
        diff = (UNIT / 16) * 3
        y = if @playfield.should_push then @y else @y+1
        @sprite.x = (@x * UNIT) - diff
        @sprite.y = (y * UNIT)  - diff
  shutdown:=>
    console.log 'shutdown cursor'
