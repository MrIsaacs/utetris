class window.Component.Menu
  constructor:->
    @cursor = new Component.MenuCursor()
  create:=>
    @sprite = game.add.sprite 40, 40, 'menu'
    @cursor.create @, 26, 39, [
      @mode_1p_vs_2p_local
      @mode_1p_vs_2p_online
      @mode_1p_vs_cpu
      @mode_improve
      @mode_option
    ]
  update:=>
    @cursor.update()
  mode_1p_vs_2p_local:=>
    game.state.start 'mode_1p_vs_2p_local'
  mode_1p_vs_2p_online:=>
    game.state.start 'mode_1p_vs_2p_online'
  mode_1p_vs_cpu:=>
    game.state.start 'mode_1p_vs_cpu'
  mode_improve:=>
    window.puzzle = _d.puzzles.skill_chain_demo_2.demo_4
    game.state.start 'mode_puzzle'
  mode_option:=>
