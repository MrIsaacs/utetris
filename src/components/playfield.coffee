### The Tetris Attack Game object
# Contains a 2d array of block objects which will be rendered on screen.
# Keeps track of blocks, chains, combos and score.
###

class window.Component.Playfield
  unit       : null
  rows       : null
  cols       : null
  blocks     : null
  newline    : null
  combo      : null
  chain      : null
  command    : null
  cursor     : null
  blank      : null
  score      : 0
  scoreText  : null
  pushTime   : 0
  pushCounter: 0
  has_ai: false
  create_cover:=>
    @g = game.add.graphics @x, @y+(@unit*(ROWS+1))
    @g.clear()
    @g.beginFill 0xFFFFFF, 1
    @g.drawRect 0, 0, @width, @unit*2
    @g.endFill()
  create_bg:=>
    @g = game.add.graphics @x, @y
    @g.clear()
    @g.beginFill 0x000000, 1
    @g.drawRect 0, 0, @width, @height
    @g.endFill()
  create:(opts={})=>
    @should_push = opts.push || false
    @unit   = (game.stage.height * 0.8) / ROWS
    @height = (ROWS+1) * @unit
    @width  = COLS     * @unit

    @x = (game.stage.width   / 2) - (@width  / 2)
    @y = (game.stage.height  / 2) - (@height / 2)

    @create_bg()

    @layer_block  = game.add.group()
    @layer_block.x  = @x
    @layer_block.y  = @y

    @layer_cursor = game.add.group()
    @layer_cursor.x = @x
    @layer_cursor.y = @y

    @stack = @new_panels ROWS
    @fill_panels @stack  , 4, 'unique'

    @create_newline 'unique'

    @command   = null

    @cursor = new Component.Cursor()
    @cursor.create @, ai: @has_ai

    if @has_ai
      @ai = new Component.Ai()
      @ai.create @, @cursor

    @chain = 0
    @pushTime = PUSHTIME
    @pushCounter = @pushTime

    @score = 0
    @score_lbl = new Component.Score()
    @score_lbl.create()

    #blank panel
    @blank = new Component.Panel()
    @blank.create @, null, null, true

    @create_cover()

    @update_neighbors()

    @render()
    return

  #darkens newline
  newline_dead:=>
    for panel in @newline
      panel.play_dead()
  # Adds a new line of blocks to the bottom of the grid and pushes the rest
  # up. If there is not enough room a the top, the game will game-over.
  # Returns 1 if succesfull.
  push:=>
    if @is_danger()
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
    @newline_dead()
  # Ends the current game.
  game_over:=>
    for i in [0...PANELS]
      @stack[i].play_face()
      @tick = ->
        console.log 'Game Over'
        return
    for i in [0...COLS]
      @newline[i].play_face()
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

  comboToScore:(combo)->
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
  chainToScore:(chain)->
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

  #Checks if any block sprites are close to the top of the grid.
  # cols is the distance to the top.
  is_danger:(cols)->
    for i in [0...COLS]
      return true if @stack[i].i != null
    false

  ### The tick function is the main function of the TaGame object.
  # It gets called every tick and executes the other internal functions.
  # It will update the grid,
  # calculate the current score,
  # spawn possible garbage,
  # updates the sprites to the correct locations in the canvas.
  ###
  tick_push:=>
    if @cursor.controls && @cursor.controls.push.isDown
      @pushCounter -= 100
    else
      @pushCounter--
    if @pushCounter <= 0
      @pushCounter = @pushTime
      @score      += @push()
  tick:=>
    @tick_push() if @should_push
    @update_neighbors()
    @update_panels_state()
    @ai.update() if @has_ai
    # combo n chain
    cnc = @update_chain_and_combo()
    if @chain
      if @chainOver()
        console.log 'chain over'
        @chain = 0

    @score_current cnc
    @render()
    return
  score_current:(cnc)=>
    if cnc[0] > 0
      console.log 'combo is ', cnc
      @score += cnc[0] * 10
      @score += @comboToScore(cnc[0])
      if cnc[1]
        @chain++
        console.log 'chain is ', @chain + 1
      if @chain
        @score += @chainToScore(@chain + 1)
      console.log 'Score: ', @score
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
    @score_lbl.update @chain, @score

    if @should_push
      lift = @y + (@pushCounter / @pushTime * @unit)
      @layer_block.y  = lift
      @layer_cursor.y = lift
