### The Tetris Attack Game object
# Contains a 2d array of block objects which will be rendered on screen.
# Keeps track of blocks, chains, combos and score.
###

class window.Component.Playfield
  @pia       : null # player number, used to detect input
  unit       : null
  rows       : null
  cols       : null
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
  land: false # when any panel has landed in the stac
  constructor:(@pi)->
    @menu_pause = new Component.MenuPause()
    @countdown  = new Component.PlayfieldCountdown()
    @cursor     = new Component.PlayfieldCursor()
    @score_lbl  = new Component.Score()
    @blank      = new Component.Panel()
    @ai         = new Component.Ai()
  create:(@stage,opts={})=>
    @sfx_swap  = game.add.audio 'sfx_swap'
    @sfx_land = []
    @sfx_land[0]  = game.add.audio 'sfx_drop0'
    @sfx_land[1]  = game.add.audio 'sfx_drop1'
    @sfx_land[2]  = game.add.audio 'sfx_drop2'
    @sfx_land[3]  = game.add.audio 'sfx_drop3'

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

    @score_lbl.create()
    @blank.create @, null, null, true
  create_after:=>
    @layer_cursor = game.add.group()
    @layer_cursor.x = @x
    @layer_cursor.y = @y

    @countdown.create @
    @cursor.create @, ai: @has_ai
    @ai.create @, @cursor if @has_ai

    @menu_pause.create @

    @render()
  create_stack:(data)=>
    @stack = @new_panels ROWS
    if data
      @fill_panels false, @stack, data
    else
      @fill_panels false, @stack, 5, 'unique'
    for panel,i in @stack
      panel.update_neighbours(i)

  push:=>
    if @is_danger(0)
      @stage.game_over()
      return 0

    stack = new Array PANELS
    for i in [COLS...PANELS]
      stack[i-COLS] = @stack[i]

    for panel,i in @newline
      ii = (PANELS-COLS)+i
      stack[ii] = panel
      stack[ii].newline = false
      stack[ii].play_live()

    @stack = stack
    @create_newline 'random'

    @cursor.y-- if @cursor.y > 1
    1
  create_newline:(mode)=>
    return unless @should_push
    @newline = @new_panels 1, mode
    @fill_panels true, @newline, 1, mode
  pause:=>
    @stage.stage_music 'pause'
    @menu_pause.pause()
    @running = false
  unpause:=>
    @stage.stage_music 'resume'
    @running = true
    @cursor.map_controls()
  game_over:=>
    is_dead = @is_danger(0)
    panel.check_dead i, is_dead for panel,i in @stack
    panel.check_dead i, is_dead for panel,i in @newline
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
  fill_panels:(newline, stack, rows, mode=null)=>
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
        if newline
          stack[i].newline = true
          stack[i].play_newline()
  update_panels:=>
    for i in SCAN_BTLR
      @stack[i].update i, @is_danger(1)
  # Update the combos and chain for the entire grid.
  # Returns [combo, chain] where
  # combo is the amount of blocks participating in the combo
  # chain is whether a chain is currently happening.
  update_chain_and_combo:=>
    #@track_tick()
    combo = 0
    chain = false
    @panels_clearing = []
    for panel,i in @stack
      cnc    = panel.chain_and_combo()
      combo += cnc[0]
      chain  = true if cnc[1]
    for panel,i in @panels_clearing
      panel.popping i
    #console.log 'chain_over_check', chain, @chain, @chain_over()
    @chain = 0 if @chain && @chain_over()
    [combo, chain]
  # Swaps two blocks at location (x,y) and (x+1,y) if swapping is possible
  swap:(x, y)=>
    i = _f.xy_2_i x, y
    if @stack[i].is_swappable() && @stack[i+1].is_swappable()
      @stack[i].swap()
  # Checks if the current chain is over.
  # returns a boolean
  chain_over:=>
    chain = true
    for panel in @stack
      chain = false if panel.chain
    chain
  is_danger:(within)=>
    offset = COLS*within
    cols  = []
    for i in [0...COLS]
      if @stack[offset+i] && @stack[offset+i].i >= 0 && @stack[offset+i].i != null
        cols.push i
    if cols.length > 0 then cols else false
  ### The tick function is the main function of the TaGame object.
  # It gets called every tick and executes the other internal functions.
  # It will update the grid,
  # calculate the current score,
  # spawn possible garbage,
  # updates the sprites to the correct locations in the canvas.
  ###
  tick_push:=>
    if @cursor.can_push()
      @pushCounter -= 100
    else
      @pushCounter--
    if @pushCounter <= 0
      @pushCounter = @pushTime
      @score      += @push()
  track_tick:=>
    @tick = 0 unless @tick >= 0
  print_tick:(with_time=false)=>
    if @tick >= 0
      if with_time
        console.log "~ #{@tick} #{Date.now()}"
      else
        console.log "~ #{@tick}"
      @tick++
  update:=>
    return unless @running
    @print_tick()
    @tick_push() if @should_push
    @update_panels()
    @ai.update() if @has_ai
    # combo n chain
    cnc = @update_chain_and_combo()
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
      console.log 'combo is ', cnc
      @score += cnc[0] * 10
      @score += @score_combo(cnc[0])
      if cnc[1]
        @chain++
        console.log 'chain is ', @chain + 1
      if @chain
        @score += @score_chain(@chain + 1)
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
    if @land is true
      i = game.rnd.integerInRange(0,3)
      @sfx_land[i].play()
      @land = false

    @cursor.update()
    @countdown.update()
    @menu_pause.update()

    @score_lbl.update @chain, @score

    if @should_push
      lift = @y + (@pushCounter / @pushTime * UNIT)
      @layer_block.y  = lift
      @layer_cursor.y = lift
  shutdown:=>
    @cursor.shutdown()
