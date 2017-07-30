class window.Component.Ai
  create:(@playfield,@cursor)=>
    console.log 'create ai'
  update:=>
    @cursor.mv_up()
    
