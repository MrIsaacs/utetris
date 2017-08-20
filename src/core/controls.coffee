class window.Core.Controls
  constructor:->
    @create()
  create:->
    @keys = game.input.keyboard.createCursorKeys()
    @keys.pl1_up    = game.input.keyboard.addKey Phaser.Keyboard.UP
    @keys.pl1_down  = game.input.keyboard.addKey Phaser.Keyboard.DOWN
    @keys.pl1_left  = game.input.keyboard.addKey Phaser.Keyboard.LEFT
    @keys.pl1_right = game.input.keyboard.addKey Phaser.Keyboard.RIGHT
    @keys.pl1_a     = game.input.keyboard.addKey Phaser.Keyboard.X
    @keys.pl1_b     = game.input.keyboard.addKey Phaser.Keyboard.Z
    @keys.pl1_l     = game.input.keyboard.addKey Phaser.Keyboard.C
    @keys.pl1_r     = game.input.keyboard.addKey Phaser.Keyboard.C
    @keys.pl1_start = game.input.keyboard.addKey Phaser.Keyboard.ENTER

    @keys.pl2_up    = game.input.keyboard.addKey Phaser.Keyboard.W
    @keys.pl2_down  = game.input.keyboard.addKey Phaser.Keyboard.S
    @keys.pl2_left  = game.input.keyboard.addKey Phaser.Keyboard.A
    @keys.pl2_right = game.input.keyboard.addKey Phaser.Keyboard.D
    @keys.pl2_a     = game.input.keyboard.addKey Phaser.Keyboard.K
    @keys.pl2_b     = game.input.keyboard.addKey Phaser.Keyboard.L
    @keys.pl2_l     = game.input.keyboard.addKey Phaser.Keyboard.J
    @keys.pl2_r     = game.input.keyboard.addKey Phaser.Keyboard.J
    @keys.pl2_start = game.input.keyboard.addKey Phaser.Keyboard.P
  map:(player_num,opts)=>
    keys = "up down left right a b l r start".split(' ')
    for key in keys
      @map_key(player_num,key,opts)
  map_key:(i,key,opts)=>
    fun =
    if opts[key]
      opts[key]
    else
      ->
    @keys["pl#{i}_#{key}"].onDown.removeAll()
    @keys["pl#{i}_#{key}"].onDown.add fun, @
