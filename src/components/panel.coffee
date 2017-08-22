class controller
  playfield         : null
  x                 : null
  y                 : null
  state             : null
  above             : null
  under             : null
  left              : null
  right             : null
  counter           : 0 #counter ie exclusivly used to count down time until clear.
  animation_state   : null
  animation_counter : 0
  chain             : null
  sprite            : null
  i                 : null

  create:(@playfield, @x, @y, blank=false)=>
    @danger = false
    @state  = STATIC
    @chain  = false
    @set_blank() if blank

    @sprite = game.make.sprite 0, 0, 'panels', @frame(0)
    @sprite.visible  = false
    @playfield.layer_block.add @sprite

  # A blank block will see itself as its neighbors.
  # It is never supposed to have a sprite and should always have a state
  # of STATIC.
  # The blank is used on the outer edges of the grid.
  set_blank:=>
    @x                 = null
    @y                 = null
    @under             = this
    @above             = this
    @left              = this
    @right             = this
    @state             = STATIC
    #@counter           = 0
    @set_counter 0
    @animation_state   = null
    @animation_counter = 0
  is_swappable:=>  @above.state != HANG and @counter is 0
  is_support:=>   @state != FALL and (@i != null or @playfield.blank is @)
  is_clearable:=>  @is_swappable() and @under.is_support() and @i != null
  is_comboable:=>  @is_clearable() or @state is CLEAR and @clearing
  is_empty:=>      @counter is 0 and @i is null and @ != @playfield.blank
  set_counter:(v)=>
    @counter = v
  matched:(i)=>
    pos = _f.xy_2_i @x, @y

    left  = @playfield.panel_i pos-1
    right = @playfield.panel_i pos+1
    under = @playfield.panel_i pos+(1*COLS)
    above = @playfield.panel_i pos-(1*COLS)

    left2  = @playfield.panel_i pos-2
    right2 = @playfield.panel_i pos+2
    under2 = @playfield.panel_i pos+(2*COLS)
    above2 = @playfield.panel_i pos-(2*COLS)

    (left  is i && right  is i) ||
    (above is i && under  is i) ||
    (above is i && above2 is i) ||
    (under is i && under2 is i) ||
    (left  is i && left2  is i) ||
    (right is i && right2 is i)

  frames:(arr)=>
    frames = []
    frames.push @frame(f) for f in arr
    frames
  frame:(i)=>
    (@i * 8) + i
  play_land:=>    @sprite.animations.play 'land' , game.time.desiredFps, false
  play_clear:=>   @sprite.animations.play 'clear', game.time.desiredFps, false
  play_live:=>    @sprite.animations.play 'live'
  play_dead:=>    @sprite.animations.play 'dead'
  play_danger:=>  @sprite.animations.play 'danger', game.time.desiredFps/3, true
  play_newline:=> @sprite.animations.play 'newline'
  
  set_animation:=>
    @sprite.frame = @frame(0)
    @sprite.animations.add 'land'   , @frames(FRAME_LAND)
    @sprite.animations.add 'clear'  , @frames(FRAME_CLEAR)
    @sprite.animations.add 'live'   , @frames(FRAME_LIVE)
    @sprite.animations.add 'danger' , @frames(FRAME_DANGER)
    @sprite.animations.add 'dead'   , @frames(FRAME_DEAD)
    @sprite.animations.add 'newline', @frames(FRAME_NEWLINE)
  set:(i)=>
    switch i
      when 'unique'
        @nocombo()
      when 'random'
        @i = game.rnd.integerInRange 0 , 5
      else
        @i = i

    unless @i is null
      @sprite.visible = true
    @set_animation()
  # Update the current state of this block based on its own state, and the
  # states of its neighbors.
  # Will keep its current state it its counter is still running.
  # Block behaviour should be described in the wiki
  update_state:(i)=>
    return if @i is null
    return if @newline
    if @counter_popping > 0
      @counter_popping--
    else if @counter_popping is 0
      @counter_popping = null
      @sprite.visible = false

    if @counter > 0
      #if @x is 2 && @y is 9
        #console.log "counter--", i
      @counter--
      return if @counter > 0
    ### Run through the state switch to determine behaviour ###
    switch @state
      when STATIC, SWAP
        if !@sprite
          @state = STATIC
          @chain = false
          return
        else if @under is @playfield.blank
          @state = STATIC
          @chain = false
        else if @under.state is HANG
          @state   = HANG
          #@counter = @under.counter
          @set_counter @under.counter
          @chain   = @under.chain
        else if @under.is_empty()
          @state   = HANG
          #@counter = HANGTIME
          @set_counter HANGTIME
        else
          @chain = false
      when HANG
        @state = FALL
      when FALL
        if @under.is_empty()
          @fall()
        else if @under.state is CLEAR
          @state = STATIC
        else
          @state   = @under.state
          #@counter = @under.counter
          @set_counter @under.counter
          @chain   = @under.chain
        if (@state is STATIC or @state is SWAP) and @sprite
          @play_land()
          @playfield.land = true
      when CLEAR
        @erase()
      else
        console.log "Unknown block state"
    return



  # Set the block sprite to the correct rendering location,
  # keeping animations and offsets in mind.
  # optional nextLine boolean determines if the block should be in the grid
  # or in the bottom line still being added.
  render:(newline)=>
    return unless @sprite
    @sprite.x = @x * UNIT
    if newline
      @sprite.y = ROWS * UNIT
    else
      y = if @playfield.should_push then @y else @y+1
      @sprite.y = y * UNIT
      @animation_state = null if @animation_counter <= 0
      @animation_counter--    if @animation_counter > 0
      switch @animation_state
        when ANIM_SWAP_LEFT
          step = UNIT / TIME_SWAP
          @sprite.x += step * @animation_counter
        when ANIM_SWAP_RIGHT
          @sprite.x -= step * @animation_counter
  # This block will give its state and sprite to the block under it and then
  # reset to an empty block.
  fall:=>
    @under.state   = @state
    #@under.counter = @counter
    @under.set_counter @counter
    @under.chain   = @chain
    @under.i       = @i
    @under.set_animation()
    @under.sprite.frame   = @sprite.frame
    @under.sprite.visible = true

    @state          = STATIC
    #@counter        = 0
    @set_counter 0
    @chain          = false
    @i              = null
    @sprite.visible = false
  # Swap this block with its right neighbour.
  swap:=>
    #swap i
    i1 = @i
    i2 = @right.i
    @i       = i2
    @right.i = i1

    #swap danger
    d1 = @danger
    d2 = @right.danger
    @danger       = d2
    @right.danger = d1

    @sprite.visible       = @i       != null
    @right.sprite.visible = @right.i != null

    @set_animation()
    @right.set_animation()

    @right.chain  = false
    @chain        = false

    unless @i is null && @right.i is null
      @playfield.sfx_swap.play()

    if @i is null
      @state   = SWAP
      #@counter = 0
      @set_counter 0
    else
      @state             = SWAP
      @set_counter TIME_SWAP
      @animation_state   = ANIM_SWAP_LEFT
      @animation_counter = TIME_SWAP

    if @right.i is null
      @right.state   = SWAP
      #@right.counter = 0
      @right.set_counter 0
    else
      @right.state             = SWAP
      @right.set_counter TIME_SWAP
      @right.animation_state   = ANIM_SWAP_RIGHT
      @right.animation_counter = TIME_SWAP
  # Erase the contents of this block and start a chain in
  # its upper neighbour.
  erase:=>
    @i              = null
    @sprite.visible = false
    @state          = STATIC
    #@counter        = 0
    @set_counter 0
    @chain          = false
    @above.chain    = true if @above && @above.i != null
  popping:(i)=>
    time = TIME_CLEAR + (TIME_POP*@playfield.panels_clearing.length) + TIME_FALL
    #@counter  = time
    @set_counter time
    @clearing = false
    @counter_popping = TIME_CLEAR + (TIME_POP*(i+1))
    #@playfield.track_tick()
  clear:=>
    return [0, @chain] if @state is CLEAR
    @clearing = true
    @state    = CLEAR
    @playfield.panels_clearing.push @
    @play_clear()
    [1, @chain]
  nocombo:=>
    values = _.shuffle [0...5]
    @i = _.find values, (i)=>
      @matched(i) is false
  chain_and_combo:=>
    combo = 0
    chain = false
    return [combo,chain] unless @is_comboable()
    [combo,chain] = @check_neighbours @left , @right, combo, chain
    [combo,chain] = @check_neighbours @above, @under, combo, chain
    [combo,chain]
  check_neighbours:(p1,p2,combo,chain)=>
    return [combo,chain] unless p1.is_comboable() && p1.i is @i  &&
                                p2.is_comboable() && p2.i is @i
    panel1  = p1.clear()
    middle  = @clear()
    panel2  = p2.clear()

    combo  += panel1[0]
    combo  += middle[0]
    combo  += panel2[0]
    chain   = true if middle[1] or panel1[1] or panel2[1]
    [combo,chain]
  check_dead:(i,is_dead)=>
    [x,y] = _f.i_2_xy(i)
    if is_dead && is_dead.indexOf(x) != -1
      @play_dead()
    else
      @play_live()
  update_neighbours:(i)=>
    @left  = if ((i+1) % COLS) is 1  then @playfield.blank else @playfield.stack[i-1]
    @right = if ((i+1) % COLS) is 0  then @playfield.blank else @playfield.stack[i+1]
    @under = if i+1 >= (PANELS-COLS) then @playfield.blank else @playfield.stack[i+COLS]
    @above = if i+1 <= COLS          then @playfield.blank else @playfield.stack[i-COLS]
  update:(i,is_danger)=>
    return unless @playfield.running
    [x,y] = _f.i_2_xy(i)
    if is_danger && is_danger.indexOf(x) != -1
      if @danger is false
        @play_danger()
      @danger = true
    else
      if @danger is true
        @play_live()
      @danger = false

    @update_neighbours(i)

    @update_state(i)
    @x = x
    @y = y


if exports?
  exports.Panel = controller
else
  window.Component.Panel = controller
