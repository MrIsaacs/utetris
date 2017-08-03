class window._f
  @i_2_xy:(i,rows,cols)->
    rows ||= ROWS
    cols ||= COLS
    y = Math.floor(i / COLS)
    x = i % COLS
    [x,y]
  @xy_2_i:(x,y)->
    (y*COLS) + x
