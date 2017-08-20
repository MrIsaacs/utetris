class window.Component.MenuCursor
  create:(@menu,@x,@y,@menu_items)=>
    @sfx_select = game.add.audio 'sfx_select'

    @counter = 0
    @index  = 0
    @sprite = game.make.sprite @x, @y+(@index*UNIT), 'menu_cursor'
    @menu.sprite.addChild @sprite

    @create_controls()
  create_controls:=>
    @controls       = game.input.keyboard.createCursorKeys()
    @controls.btn_a = game.input.keyboard.addKey Phaser.Keyboard.X
    @controls.btn_b = game.input.keyboard.addKey Phaser.Keyboard.Z
    @controls.btn_l = game.input.keyboard.addKey Phaser.Keyboard.C
    @controls.btn_r = game.input.keyboard.addKey Phaser.Keyboard.C

    @controls.up.onDown.add        @up   , @
    @controls.down.onDown.add      @down , @
    @controls.left.onDown.add      @left , @
    @controls.right.onDown.add     @right, @

    @controls.btn_a.onDown.add  @btn_a, @
    @controls.btn_b.onDown.add  @btn_b, @
    @controls.btn_l.onDown.add  @btn_l, @
    @controls.btn_r.onDown.add  @btn_r, @
      #'mode_1p_vs_2p_local'
      #'mode_1p_vs_2p_online'
      #'mode_1p_vs_cpu'
      #'mode_improve'
      #'mode_option'
  update:=>
    @sprite.y = @y+(@index*UNIT)
    @counter++
    if @counter > MENUCURSORBLINK
      @counter = 0
      @sprite.visible = !@sprite.visible
  up:=>
    unless @index is 0
      @sfx_select.play()
      @counter = 0
      @sprite.visible = true
      @index--
  down:=>
    unless @index is @menu_items.length-1
      @sfx_select.play()
      @counter = 0
      @sprite.visible = true
      @index++
  left:=>
  right:=>
    @menu_items[@index]()
  btn_a:=>
    @menu_items[@index]()
  btn_b:=>
  btn_l:=>
  btn_r:=>
