### The Tetris Attack Game object
# Contains a 2d array of block objects which will be rendered on screen.
# Keeps track of blocks, chains, combos and score.
###

class window.Component.Playfield
  @pia       : null # player number, used to detect input
  unit       : null
  rows       : null
  cols       : null
  blocks     : null
  newline    : null
  combo      : null
  chain      : null
  cursor     : null
  blank      : null
  score      : 0
  scoreText  : null
  pushTime   : 0
  pushCounter: 0
  has_ai: false
  running: false
  constructor:(@pi)->
    @menu_pause = new Component.MenuPause()
    @cursor     = new Component.PlayfieldCursor()
    @score_lbl  = new Component.Score()
    @blank      = new Component.Panel()
    @ai         = new Component.Ai()
  create:(@stage,opts={})=>
    @sfx_swap  = game.add.audio 'sfx_swap'

    @should_push = opts.push || false

    @height = (ROWS+1) * UNIT
    @width  = COLS     * UNIT

    @x = opts.x
    @y = opts.y

    @layer_block  = game.add.group()
    @layer_block.x  = @x
    @layer_block.y  = @y

    @create_stack   opts.panels
    @create_newline 'unique'

    @score       = 0
    @chain       = 0
    @pushTime    = PUSHTIME
    @pushCounter = @pushTime

    @menu_pause.create @
    @score_lbl.create()
    @blank.create @, null, null, true

    @update_neighbors()

    @running = true
    return
  create_cursor:=>
    @layer_cursor = game.add.group()
    @layer_cursor.x = @x
    @layer_cursor.y = @y

    @cursor.create @, ai: @has_ai
    @ai.create @, @cursor if @has_ai
  create_stack:(data)=>
    @stack = @new_panels ROWS
    if data
      @fill_panels @stack, data
    else
      @fill_panels @stack, 4, 'unique'
  push:=>
    if @is_dead()
      @game_over()
      return 0

    stack = new Array PANELS
    for i in [COLS...PANELS]
      stack[i-COLS] = @stack[i]

    for panel,i in @newline
      ii = (PANELS-COLS)+i
      stack[ii] = panel
      stack[ii].play_live()

    @stack = stack
    @create_newline 'random'

    @cursor.y-- if @cursor.y > 1
    1

  create_newline:(mode)=>
    return unless @should_push
    @newline = @new_panels 1, mode
    @fill_panels @newline, 1, mode
    for panel in @newline
      panel.play_dead()
  pause:=>
    @menu_pause.pause()
    @running = false
  unpause:=>
    @running = true
    @cursor.map_controls()
  game_over:=>
    @stack[i].play_face()   for i in [0...PANELS]
    @newline[i].play_face() for i in [0...COLS]
    @running = false
    console.log 'gameover',
      @stack[0].i
      @stack[1].i
      @stack[2].i
      @stack[3].i
      @stack[4].i
      @stack[5].i
    @pushCounter = 0
    return
  #grid of blocks
  new_panels:(rows)=>
    size   = COLS * rows
    panels = new Array size
    for i in [0...size]
      [x,y] = _f.i_2_xy i
      panels[i] = new Component.Panel()
      panels[i].create @, x, y
    panels
  fill_panels:(stack, rows, mode=null)=>
    if _.isArray(rows)
      data    = rows
      offset  = (ROWS - (data.length / COLS)) * COLS

      for color,i in data
        stack[offset+i].set color
    else
      offset = ((stack.length / COLS) - rows) * COLS

      size = rows * COLS
      for i in [offset...offset+size]
        switch mode
          when 'unique' then stack[i].set 'unique'
          when 'random' then stack[i].set 'random'
          else
            stack[i].set mode[i]
  # Updates the neighbor references in each block in the grid.
  update_neighbors:=>
    for panel,i in @stack
      panel.left  = if ((i+1) % COLS) is 1  then @blank else @stack[i-1]
      panel.right = if ((i+1) % COLS) is 0  then @blank else @stack[i+1]
      panel.under = if i+1 >= (PANELS-COLS) then @blank else @stack[i+COLS]
      panel.above = if i+1 <= COLS          then @blank else @stack[i-COLS]
  # Updates the state of the grid.
  # Blocks are only dependent on the state of their under-neighbor, so
  # this can be done from the bottom up.
  update_panels_state:=>
    for panel,i in @stack
      [x,y] = _f.i_2_xy(i)
      panel.update_state()
      panel.x = x
      panel.y = y
  # Update the combos and chain for the entire grid.
  # Returns [combo, chain] where
  # combo is the amount of blocks participating in the combo
  # chain is whether a chain is currently happening.
  update_chain_and_combo:=>
    combo = 0
    chain = false
    for panel,i in @stack
      cnc = panel.chain_and_combo()
      combo += cnc[0]
      chain = true if cnc[1]
    [combo, chain]
  
  # Swaps two blocks at location (x,y) and (x+1,y) if swapping is possible
  swap:(x, y)=>
    i = _f.xy_2_i x, y
    if @stack[i].is_swappable() && @stack[i+1].is_swappable()
      @stack[i].swap()
  # Checks if the current chain is over.
  # returns a boolean
  chainOver:=>
    chain = true
    for panel in @stack
      chain = false if panel.chain
    chain
  is_danger:=>
    offset = COLS*3
    for i in [0...COLS]
      if @stack[offset+i] && @stack[offset+i].i >= 0 && @stack[offset+i].i != null
        return true 
    false
  is_dead:=>
    for i in [0...COLS]
      if @stack[i] && @stack[i].i >= 0 && @stack[i].i != null
        return true 
    false

  ### The tick function is the main function of the TaGame object.
  # It gets called every tick and executes the other internal functions.
  # It will update the grid,
  # calculate the current score,
  # spawn possible garbage,
  # updates the sprites to the correct locations in the canvas.
  ###
  tick_push:=>
    @stage.tick_danger(@is_danger())

    if _d.controls.keys["pl#{@pi}_l"].isDown ||
       _d.controls.keys["pl#{@pi}_r"].isDown &&
       @running
      @pushCounter -= 100
    else
      @pushCounter--
    if @pushCounter <= 0
      @pushCounter = @pushTime
      @score      += @push()
  tick:=>
    return unless @running
    @tick_push() if @should_push
    @update_neighbors()
    @update_panels_state()
    @ai.update() if @has_ai
    # combo n chain
    cnc = @update_chain_and_combo()
    if @chain
      if @chainOver()
        #console.log 'chain over'
        @chain = 0

    @score_current cnc
    @render()
    return
  score_combo:(combo)->
    switch combo
      when 4 then 20
      when 5 then 30
      when 6 then 50
      when 7 then 60
      when 8 then 70
      when 9 then 80
      when 10 then 100
      when 11 then 140
      when 12 then 170
      else
        0
  score_chain:(chain)->
    switch chain
      when 2  then 50
      when 3  then 80
      when 4  then 150
      when 5  then 300
      when 6  then 400
      when 7  then 500
      when 8  then 700
      when 9  then 900
      when 10 then 1100
      when 11 then 1300
      when 12 then 1500
      when 13 then 1800
      else
        0
  score_current:(cnc)=>
    if cnc[0] > 0
      #console.log 'combo is ', cnc
      @score += cnc[0] * 10
      @score += @score_combo(cnc[0])
      if cnc[1]
        @chain++
        #console.log 'chain is ', @chain + 1
      if @chain
        @score += @score_chain(@chain + 1)
      #console.log 'Score: ', @score
  update_stack:=>
    for panel in @stack
      panel.render()
  update_newline:=>
    for panel in @newline
      panel.render true
  panel_i:(i)=>
    if @stack[i] && @stack[i].i != null
      @stack[i].i
    else
      null
  render:->
    @update_stack()
    @update_newline() if @should_push

    @cursor.update()
    @menu_pause.update()

    @score_lbl.update @chain, @score

    if @should_push
      lift = @y + (@pushCounter / @pushTime * UNIT)
      @layer_block.y  = lift
      @layer_cursor.y = lift
  shutdown:=>
    @cursor.shutdown()
