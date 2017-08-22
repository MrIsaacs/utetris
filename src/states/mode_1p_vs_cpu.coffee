class controller
  constructor:->
    @playfield1 = new Component.Playfield(1)
    @playfield2 = new Component.Playfield(2)
    window.pl = @playfield1
  create_bg:=>
    @bg = game.add.sprite 0,0, 'playfield_vs_bg'
  create_frame:(offset)=>
    @frame = game.add.sprite offset,0, 'playfield_vs_frame'
  create:=>
    game.stage.backgroundColor = 0x000000

    @state_music = 'stop'

    @danger = false
    @msx_stage_results  = game.add.audio 'msx_stage_results'
    @msx_stage          = game.add.audio 'msx_stage'
    @msx_stage_critical = game.add.audio 'msx_stage_critical'

    offset = 89
    @create_bg()
    @playfield1.create @, push: true, x: offset+8  , y: 24
    @playfield2.create @, push: true, x: offset+152, y: 24
    @create_frame(offset)
    @playfield1.create_after()
    @playfield2.create_after()
  stage_music:(state)=>
    switch state
      when 'pause'
        switch @state_music
          when 'active' then @msx_stage.pause()
          when 'danger' then @msx_stage_critical.pause()
      when 'resume'
        switch @state_music
          when 'active' then @msx_stage.resume()
          when 'danger' then @msx_stage_critical.resume()
      when 'none'
        @state_music = state
        @msx_stage.stop()
        @msx_stage_critical.stop()
        @msx_stage_results.stop()
      when 'active'
        return if @state_music is 'active'
        @state_music = state
        @msx_stage.play()
        @msx_stage_critical.stop()
        @msx_stage_results.stop()
      when 'danger'
        return if @state_music is 'danger'
        @state_music = state
        @msx_stage.stop()
        @msx_stage_critical.play()
        @msx_stage_results.stop()
      when 'results'
        return if @state_music is 'results'
        @state_music = state
        @msx_stage.stop()
        @msx_stage_critical.stop()
        @msx_stage_results.play()
  game_over:=>
    @stage_music 'results'
    @playfield1.game_over()
    @playfield2.game_over()
  danger_check:=>
    d1 = @playfield1.is_danger 1
    d2 = @playfield2.is_danger 2

    if d1 || d2
      if @danger is false
        @stage_music 'danger'
      @danger = true
    else
      if @danger is true
        @stage_music 'active'
      @danger = false
  update:=>
    @playfield1.update()
    @playfield2.update()

    @danger_check()

    @playfield1.render()
    @playfield2.render()
  shutdown:=>
    @stage_music 'none'
    @playfield1.shutdown()
ctrl = new controller()
_states.mode_1p_vs_cpu =
  create   : ctrl.create
  update   : ctrl.update
  shutdown : ctrl.shutdown
