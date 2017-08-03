class window.Component.Cursor
  x          : null
  y          : null
  left       : null
  right      : null
  sprite     : null
  game       : null
  controls   : null
  create:(@playfield,opts={})=>
    # center the cursor
    @ai = opts.ai || false
    console.log 'ai', @ai

    @x = Math.floor(COLS / 2) - 1
    @y = Math.floor(ROWS / 3)

    i = _f.xy_2_i @x, @y
    @left  = @playfield.stack[i]
    @right = @playfield.stack[i+1]

    @sprite = game.make.sprite 0, 0, 'cursor', 0
    @sprite.scale.setTo  (@playfield.unit / 16)
    @sprite.smoothed = false
    @sprite.animations.add  'idle', [0,1]
    @sprite.animations.play 'idle', Math.round(game.time.desiredFps / 10), true

    @playfield.layer_cursor.add @sprite
    @create_controls() if @ai is false
  create_controls:=>
    @controls      = game.input.keyboard.createCursorKeys()
    @controls.swap = game.input.keyboard.addKey Phaser.Keyboard.X
    if @playfield.should_push
      @controls.push = game.input.keyboard.addKey Phaser.Keyboard.C
    @controls.left.onDown.add  @mv_left , @
    @controls.right.onDown.add @mv_right, @
    @controls.down.onDown.add  @mv_down , @
    @controls.up.onDown.add    @mv_up   , @
    @controls.swap.onDown.add  @mv_swap , @
  update:=>
    diff = (@playfield.unit / 16) * 3
    y = if @playfield.should_push then @y else @y+1
    @sprite.x = (@x * @playfield.unit) - diff
    @sprite.y = (y * @playfield.unit)  - diff
  mv_swap:=>          @playfield.swap @x, @y
  mv_left:=>          @x-- if @x > 0
  mv_right:(cursor)=> @x++ if @x < COLS - 2
  mv_down:(cursor)=>  @y++ if @y < ROWS - 1
  mv_up:(cursor)=>    @y-- if @y > 0
