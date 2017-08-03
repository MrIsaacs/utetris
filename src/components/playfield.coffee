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
    @g = game.add.graphics @x, @y+(@unit*(COLS+1))
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
    @unit   = (game.stage.height * 0.8) / COLS
    @height = (COLS+1) * @unit
    @width  = ROWS     * @unit

    @x = (game.stage.width   / 2) - (@width  / 2)
    @y = (game.stage.height  / 2) - (@height / 2)

    @create_bg()

    @layer_block  = game.add.group()
    @layer_block.x  = @x
    @layer_block.y  = @y

    @layer_cursor = game.add.group()
    @layer_cursor.x = @x
    @layer_cursor.y = @y

    @stack    = @new_blocks ROWS, COLS
    @newline  = @new_blocks 6, 1 if @should_push

    @fill_blocks @stack  , 6, 4, 'unique'
    @fill_blocks @newline, 6, 1, 'unique' if @should_push
    @newline_dead() if @should_push

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
    for x in [0...ROWS]
      @newline[x][0].play_dead()
  # Adds a new line of blocks to the bottom of the grid and pushes the rest
  # up. If there is not enough room a the top, the game will game-over.
  # Returns 1 if succesfull.
  push:=>
    if @is_danger()
      @game_over()
      return 0
    blocks = @new_blocks ROWS, COLS

    for x in [0...ROWS]
      for y in [0...COLS-1]
        blocks[x][y + 1] = @stack[x][y]
      @stack[x][COLS - 1].erase()
      blocks[x][0] = @newline[x][0]
      blocks[x][0].play_live()
    @stack   = blocks

    @newline = @new_blocks 6, 1, 'random'
    @fill_blocks @newline, 6, 1, 'random'

    @newline_dead()
    @cursor.y++ if @cursor.y < COLS - 1
    1

  # Ends the current game.
  game_over:=>
    for x in [0...ROWS]
      for y in [0...COLS]
        if @stack[x][y].sprite
          @stack[x][y].play_face()
        @tick = ->
          console.log 'Game Over'
          return
      @newline[x][0].play_face()
    @pushCounter = 0
    return
  #grid of blocks
  new_blocks:(rows, cols)=>
    panels = new Array rows
    for x in [0...rows]
      panels[x] = new Array(cols)
      for y in [0...cols]
        panels[x][y] = new Component.Panel()
        panels[x][y].create @, x, y
    panels
  fill_blocks:(stack, rows, cols, mode=null)=>
    for x in [0...rows]
      for y in [0...cols]
        switch mode
          when 'unique' then stack[x][y].set 'unique'
          when 'random' then stack[x][y].set 'random'
          else
            stack[x][y].set mode[x][y]
  # Updates the neighbor references in each block in the grid.
  update_neighbors:=>
    panel = undefined
    for x in [0...ROWS]
      for y in [0...COLS]
        panel = @stack[x][y]
        panel.left  = if x > 0         then @stack[x - 1][y] else @blank
        panel.right = if x < ROWS - 1 then @stack[x + 1][y] else @blank
        panel.under = if y > 0         then @stack[x][y - 1] else @blank
        panel.above = if y < COLS - 1 then @stack[x][y + 1] else @blank

  # Updates the state of the grid.
  # Blocks are only dependent on the state of their under-neighbor, so
  # this can be done from the bottom up.
  update_panels_state:=>
    for x in [0...ROWS]
      for y in [0...COLS]
        @stack[x][y].update_state()
        @stack[x][y].x = x
        @stack[x][y].y = y
  # Update the combos and chain for the entire grid.
  # Returns [combo, chain] where
  # combo is the amount of blocks participating in the combo
  # chain is whether a chain is currently happening.
  update_chain_and_combo:=>
    combo = 0
    chain = false
    for x in [0...ROWS]
      for y in [0...COLS]
        do (x,y)=>
          cnc = @stack[x][y].chain_and_combo()
          combo += cnc[0]
          chain = true if cnc[1]
    [combo, chain]
  # Swaps two blocks at location (x,y) and (x+1,y) if swapping is possible
  swap:(x, y)=>
    if @stack[x][y].is_swappable() && @stack[x+1][y].is_swappable()
      @stack[x][y].swap()
  # Checks if the current chain is over.
  # returns a boolean
  chainOver:=>
    chain = true
    for x in [0...ROWS]
      for y in [0...COLS]
        chain = false if @stack[x][y].chain
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
    for x in [0...ROWS]
      return true if @stack[x][COLS-1].i != null
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
    for x in [0...ROWS]
      for y in [0...COLS]
        @stack[x][y].render()
  update_newline:=>
    for x in [0...ROWS]
      @newline[x][0].render true
  panel_i:(x,y)=>
    if @stack[x] && @stack[x][y] && @stack[x][y].i != null
      @stack[x][y].i
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
