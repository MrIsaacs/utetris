sizzle    = null
titlecard = null

fadein = =>
  if _d.get_sound()
    sizzle.fadeIn(200)
  tween = game.add.tween titlecard
  tween.to { alpha: 1 }, 750 , Phaser.Easing.Linear.None
  tween.to { alpha: 1 }, 3500, Phaser.Easing.Linear.None
  tween.onComplete.add fadeout, this
  tween.start()
fadeout = =>
  if _d.get_sound()
    sizzle.fadeOut(800)
  tween = game.add.tween titlecard
  tween.to { alpha: 0 }, 1000 , Phaser.Easing.Linear.None
  tween.onComplete.add complete, this
  tween.start()
fadeout_card = =>

complete = ->
  game.state.start 'menu'

_states.load =
  create: ->
    _d.load()
    game.state.start 'menu'

    #titlecard = game.add.image 0, 0, 'splash'
    #titlecard.scale.setTo _rez.scale
    #titlecard.alpha = 0

    #sizzle = game.add.audio 'sizzle'
    #if _d.get_sound()
      #sizzle.onDecoded.add fadein, this
    #else
      #fadein()
