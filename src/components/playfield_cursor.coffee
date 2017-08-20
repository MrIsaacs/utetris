class window.Component.PlayfieldCursor
  x          : null
  y          : null
  left       : null
  right      : null
  sprite     : null
  game       : null
  controls   : null
  animating_start_pos: true
  create:(@playfield,opts={})=>
    @counter = 0


    @sfx_select = game.add.audio 'sfx_select'

    # center the cursor
    @ai = opts.ai || false
    console.log 'ai', @ai

    @x = 2
    @y = 6

    diff = (UNIT / 16) * 3
    @sprite = game.make.sprite ((COLS-2)*UNIT)-diff, 0-diff, 'playfield_cursor', 0
    @sprite.animations.add  'idle', [0,1]
    @sprite.animations.play 'idle', Math.round(game.time.desiredFps / 10), true

    @playfield.layer_cursor.add @sprite
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
    console.log 'pause'
    @playfield.pause()
  up:=>
    return unless @playfield.running
    @sfx_select.play()
    @y-- if @y > 0
  down:=>
    return unless @playfield.running
    @sfx_select.play()
    @y++ if @y < ROWS - 1
  left:=>
    return unless @playfield.running
    @sfx_select.play()
    @x-- if @x > 0
  right:=>
    return unless @playfield.running
    @sfx_select.play()
    @x++ if @x < COLS - 2
  swap:=>
    return unless @playfield.running
    @playfield.swap @x, @y
  update:=>
    diff = (UNIT / 16) * 3
    y    = if @playfield.should_push then @y else @y+1
    x    = (@x * UNIT) - diff
    y    = (y * UNIT)  - diff
    if @animating_start_pos
      if @sprite.y < y
        @sprite.y += STARTPOS_PANELCURSOR_SPEED
      else if @sprite.x > x
        @sprite.x -= STARTPOS_PANELCURSOR_SPEED
      else
        @animating_start_pos = false
        @map_controls() if @ai is false
    else
      diff = (UNIT / 16) * 3
      y = if @playfield.should_push then @y else @y+1
      @sprite.x = (@x * UNIT) - diff
      @sprite.y = (y * UNIT)  - diff
