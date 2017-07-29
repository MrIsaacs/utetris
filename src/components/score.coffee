class window.Component.Score
  create:=>
    @lbl = game.add.text 0, 0, '0',
      fontSize: '10px'
      fill: '#fff'
    @lbl.setTextBounds 50, 0, 46, 32
    @lbl.boundsAlignH = 'right'
    @lbl.align        = 'right'
    @lbl.lineSpacing  = -7

  update:(chain,score)=>
    text  = '' + score
    text += '\nchain: ' + chain + 1 if chain
    @lbl = text
