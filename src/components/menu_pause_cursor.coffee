class window.Component.MenuPauseCursor
  create:(@menu,@x,@y,@menu_items)=>
    @sfx_select = game.add.audio 'sfx_select'

    @index  = 0
    @sprite = game.make.sprite @x, @y+(@index*UNIT), 'menu_pause_cursor'
    @menu.sprite.addChild @sprite
  map_controls:=>
    console.log 'mapping menu paused', @menu.playfield.pi
    _d.controls.map @menu.playfield.pi,
      up   : @up
      down : @down
      a    : @confirm
      start: @confirm
  confirm:=>
    @menu_items[@index]()
  up:=>
    unless @index is 0
      @sfx_select.play()
      @index--
  down:=>
    unless @index is @menu_items.length-1
      @sfx_select.play()
      @index++
  update:=>
    @sprite.y = @y+(@index*12)
