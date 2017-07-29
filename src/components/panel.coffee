class window.Component.Panel
  playfield         : null
  x                 : null
  y                 : null
  state             : null
  above             : null
  under             : null
  left              : null
  right             : null
  counter           : 0
  animation_state   : null
  animation_counter : 0
  chain             : null
  sprite            : null

  create:(@playfield, @x, @y, wall=false)=>
    @state = STATIC
    @chain = false
    @set_wall() if wall

  # A wall block will see itself as its neighbors.
  # It is never supposed to have a sprite and should always have a state
  # of STATIC.
  # The wall is used on the outer edges of the grid.
  set_wall:=>
    @x                 = null
    @y                 = null
    @under             = this
    @above             = this
    @left              = this
    @right             = this
    @state             = STATIC
    @counter           = 0
    @animation_state   = null
    @animation_counter = 0

  # if stops other panels from falling.
  is_support:=>   @state != FALL and (@sprite != null or @playfield.wall is @)
  is_clearable:=> @is_swappable() and @under.is_support() and @sprite != null
  is_comboable:=> @is_clearable() or @state is CLEAR and @counter is CLEARBLINKTIME
  is_empty:=>     @counter is 0 and @sprite is null and @ != @playfield.wall
  # Whether this block can be swapped or not.
  # Blocks can be swapped as long as no counter is running.
  # Blocks cannot be swapped underneath a block about to fall from hang
  is_swappable:=>
    return false if @above.state is HANG
    @counter is 0

  # Make this block a new block.
  # Adds a sprite to the block, and animations to the sprite. Will
  # overwrite any sprite already present.
  #
  # optional i is an int indicating which sprite should be used.
  # If none is specified, a random sprite will be picked.
  set:(i)=>
    i = Math.floor(Math.random() * NRBLOCK) unless i
    # Check if there is no other sprite, otherwise it will stay onscreen###
    @erase() if @sprite
    @sprite = game.make.sprite 0, 0, "block#{i}", 0
    @sprite.scale.setTo  (@playfield.unit / 16)
    @sprite.smoothed = false

    @sprite.animations.add 'land'  , [4,2,3,0]
    @sprite.animations.add 'clear' , [6,0,6,0,6,0,6,0,6,0,6,0,6,0,5]
    @sprite.animations.add 'live'  , [0]
    @sprite.animations.add 'dead'  , [1]
    @sprite.animations.add 'danger', [0,4,0,3,2,3]
    @sprite.animations.add 'face'  , [5]
    @playfield.layer_block.add @sprite
    return

  # Update the current state of this block based on its own state, and the
  # states of its neighbors.
  # Will keep its current state it its counter is still running.
  # Block behaviour should be described in the wiki
  update_state:=>
    ### If the block has a counter, decrement it, return if it is not done###
    if @counter > 0
      @counter--
      return if @counter > 0
    ### Run through the state switch to determine behaviour ###
    switch @state
      when STATIC, SWAP
        if !@sprite
          @state = STATIC
          @chain = false
          return
        else if @under is @playfield.wall
          @state = STATIC
          @chain = false
        else if @under.state is HANG
          @state   = HANG
          @counter = @under.counter
          @chain   = @under.chain
        else if @under.is_empty()
          @state   = HANG
          @counter = HANGTIME
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
          @counter = @under.counter
          @chain   = true if @under.chain
        if (@state is STATIC or @state is SWAP) and @sprite
          @sprite.animations.play 'land', game.time.desiredFps, false
      when CLEAR
        @erase()
      else
        console.log 'Unknown block state!'
    return

  # Set the block sprite to the correct rendering location,
  # keeping animations and offsets in mind.
  # optional nextLine boolean determines if the block should be in the grid
  # or in the bottom line still being added.
  render:(newline)=>
    return unless @sprite
    @sprite.x = @x * @playfield.unit
    if newline
      @sprite.y = @playfield.cols * @playfield.unit
    else
      @sprite.y = @playfield.cols * @playfield.unit - ((@y + 1) * @playfield.unit)
      @animation_state = null if @animation_counter <= 0
      @animation_counter--    if @animation_counter > 0
      switch @animation_state
        when ANIM_SWAP_LEFT
          step = @playfield.unit / ANIM_SWAPTIME
          @sprite.x += step * @animation_counter
        when ANIM_SWAP_RIGHT
          @sprite.x -= step * @animation_counter
        #when ANIM_CLEAR, ANIM_LAND
  # This block will give its state and sprite to the block under it and then
  # reset to an empty block.
  fall:=>
    @under.state   = @state
    @under.counter = @counter
    @under.sprite  = @sprite
    @under.chain   = @chain
    @state         = STATIC
    @counter       = 0
    @sprite        = null
    @chain         = false
  # Swap this block with its right neighbour.
  swap:=>
    temp_sprite   = @right.sprite
    @right.sprite = @sprite
    @right.chain  = false
    @sprite       = temp_sprite
    @chain        = false
    if @sprite is null
      @state   = SWAP
      @counter = 0
    else
      @state             = SWAP
      @counter           = SWAPTIME
      @animation_state   = ANIM_SWAP_LEFT
      @animation_counter = ANIM_SWAPTIME
    if @right.sprite is null
      @right.state   = SWAP
      @right.counter = 0
    else
      @right.state             = SWAP
      @right.counter           = SWAPTIME
      @right.animation_state   = ANIM_SWAP_RIGHT
      @right.animation_counter = ANIM_SWAPTIME
  # Erase the contents of this block and start a chain in
  # its upper neighbour.
  erase:=>
    @sprite.destroy() if @sprite
    @sprite      = null
    @state       = STATIC
    @counter     = 0
    @chain       = false
    @above.chain = true if @above.sprite
  # Sets this blocks state to CLEAR.
  # returns [combo, chain] where
  # combo is an int represeting the nr of blocks that are set to clear.
  # chain is a boolean telling if this block is part of a chain.
  clear:=>
    return [0, @chain] if @state is CLEAR
    @counter = CLEARBLINKTIME
    @state   = CLEAR
    @sprite.animations.play 'clear', game.time.desiredFps, false
    [1, @chain]
  # Combos and Chains the current block with its neighbours.
  # returns [combo, chain] where
  # combo is an int represeting the nr of blocks participating in the combo.
  # chain is a boolean telling if this combo is part of a chain.
  chain_and_combo:=>
    combo = 0
    chain = false
    return [combo,chain] if !@is_comboable()
    if @left.is_comboable() and @right.is_comboable()
      if @left.sprite.key  is @sprite.key and
         @right.sprite.key is @sprite.key
        middle = @clear()
        left   = @left.clear()
        right  = @right.clear()
        combo += middle[0]
        combo += left[0]
        combo += right[0]
        chain  = true if middle[1] or left[1] or right[1]
    if @above.is_comboable() and @under.is_comboable()
      if @above.sprite.key is @sprite.key and
         @under.sprite.key is @sprite.key
        middle = @clear()
        above  = @above.clear()
        under  = @under.clear()
        combo += middle[0]
        combo += above[0]
        combo += under[0]
        chain  = true if middle[1] or above[1] or under[1]
    [combo,chain]
