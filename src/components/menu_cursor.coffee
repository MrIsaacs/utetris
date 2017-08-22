class window.Component.MenuCursor
  create:(@menu,@x,@y,@menu_items)=>
    @sfx_confirm = game.add.audio 'sfx_confirm'
    @sfx_select  = game.add.audio 'sfx_select'

    @counter = 0
    @index  = 0
    @sprite = game.make.sprite @x, @y+(@index*UNIT), 'menu_cursor'
    @menu.sprite.addChild @sprite

    @map_controls 1
    @map_controls 2
  map_controls:(pi)=>
    _d.controls.map pi,
      up   : @up
      down : @down
      a    : @confirm
      b    : @cancel
      start: @confirm
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
  confirm:=>
    @sfx_confirm.play()
    @menu_items[@index]()
  cancel:=>
    console.log 'cancel'
  update:=>
    @sprite.y = @y+(@index*UNIT)
    @counter++
    if @counter > MENUCURSORBLINK
      @counter = 0
      @sprite.visible = !@sprite.visible
