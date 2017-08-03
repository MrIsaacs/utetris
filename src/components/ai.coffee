class window.Component.Ai
  create:(@playfield,@cursor)=>
    console.log 'create ai'
    @plan = false
  update:=>
    @cursor.mv_up()

    if @plan is false
      stack = []
      for x in [0...@playfield.rows]
        for y in [0...@playfield.cols]
          panel = @playfield.stack[x][y]
          stack.push panel.i
      console.log 'ai stack', stack
    @plan = true

