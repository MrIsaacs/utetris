class window._f
  @i_2_xy:(rows,cols,i)->
    y = Math.floor(i / cols) - 1
    x = rows - (((y+1) * cols) - i)
    [y,x]
