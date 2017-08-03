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

    @x = Math.floor(ROWS / 2) - 1
    @y = Math.floor(COLS / 3)

    @left  = @playfield.stack[@x][@y]
    @right = @playfield.stack[@x + 1][@y]

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
    y = if @playfield.should_push then @y+1 else @y
    @sprite.x = (@x * @playfield.unit) - diff
    @sprite.y = COLS * @playfield.unit - ((y) * @playfield.unit) - diff
  mv_swap:=>          @playfield.swap @x, @y
  mv_left:=>          @x-- if @x > 0
  mv_right:(cursor)=> @x++ if @x < ROWS - 2
  mv_down:(cursor)=>  @y-- if @y > 0
  mv_up:(cursor)=>    @y++ if @y < COLS - 1
