class window.Component.Score
  create:=>
    @lbl = game.add.text 100, 100, '0',
      fontSize: '32px'
      fill: 0x000000
    @lbl.y = 200
    rsto @lbl
    @lbl.setTextBounds 50, 0, 46, 32
    @lbl.boundsAlignH = 'right'
    @lbl.align        = 'right'
    @lbl.lineSpacing  = -7

  update:(chain,score)=>
    text  = '' + score
    text += '\nchain: ' + chain + 1 if chain
    @lbl.setText text
