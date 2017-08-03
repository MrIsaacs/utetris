class window.Component.ButtonMenu
  constructor:(@key)->
  create:(x,y,xx,text)=>
    @lbl = game.make.text xx, -20, text,
      font: '28px Arial'
      fill: '#074c62'
      align: 'center'
      fontWeight: 'bold'
      fontStyle: 'italic'

    @sprite = game.add.sprite x, y, "button_menu"
    @sprite.scale.setTo _rez.scale
    @sprite.anchor.setTo 0.5
    @sprite.inputEnabled = true
    @sprite.events.onInputOut.add  @onout  , @
    @sprite.events.onInputOver.add @onover , @
    @sprite.events.onInputUp.add   @onclick, @

    @sprite.addChild @lbl
  onclick:=>
    switch @key
      when 'mode_1p_vs_cpu'
        game.state.start 'mode_1p_vs_cpu'
      when 'mode_1p_vs_2p'
        game.state.start 'mode_1p_vs_2p'
      when 'mode_puzzles'
        window.puzzle = _d.puzzles.skill_chain_demo_2.demo_4
        game.state.start 'mode_puzzle'
  onover:=>
    s = _rez.scale + 0.04
    tween = game.add.tween @sprite.scale
    tween.to {x: s, y: s} ,70, Phaser.Easing.Linear.None
    tween.start()
  onout:=>
    s = _rez.scale
    tween = game.add.tween @sprite.scale
    tween.to {x: s, y: s} ,70, Phaser.Easing.Linear.None
    tween.start()

