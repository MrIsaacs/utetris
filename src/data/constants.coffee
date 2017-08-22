root = exports ? window
# Playfield size
root.ROWS = 11
root.COLS = 6
root.PANELS = root.ROWS * root.COLS
#number of starting blocks
root.NRBLOCK = 17
# States
root.STATIC = 0
root.HANG   = 1
root.FALL   = 2
root.SWAP   = 3
root.CLEAR  = 4
# Animation Frame
root.FRAME_LAND    = [4,4,4,2,2,2,3,3,3,0]
root.FRAME_CLEAR   = [6,0,6,0,6,0,6,0,6,0,6,0
                      6,0,6,0,6,0,6,0,6,0,6,0
                      6,0,6,0,6,0,6,0,6,0,6,0
                      6,0,6,0,6,0,6,0,5,5,5,5
                      5,5,5,5,5,5,5,5,5,5,5,5]

root.FRAME_LIVE    = [0]
root.FRAME_DANGER  = [0,4,0,3,2,3]
root.FRAME_DEAD    = [5]
root.FRAME_NEWLINE = [1]

# Animation states
root.ANIM_SWAP_LEFT  = 0
root.ANIM_SWAP_RIGHT = 1
root.ANIM_LAND       = 2
root.ANIM_CLEAR      = 3

# Timing
root.TIME_CLEAR = root.FRAME_CLEAR.length #the time it takes before the first panel is ready to start popping
root.TIME_POP   = 9                  #when a panel is ready to pop is needs to wait for time_pop before popping
root.TIME_FALL  = 3                  # how long to wait after popping last panel before panel falls


root.HANGTIME         = 11
root.FALLTIME         = 4
root.TIME_SWAP        = 4
root.CLEARPAUSETIME   = 23
root.CLEAREXPLODETIME = 9
root.PUSHTIME         = 1000

root.UNIT = 16
root.WIN_WIDTH  = 434 #256
root.WIN_HEIGHT = 224

root.MENUCURSORBLINK = 12

root.STARTPOS_PANELCURSOR_SPEED = 6


# scan bottom to top, left to right.
# I was too lazy to use math so I wrote out
# the indexes by hand.
root.SCAN_BTLR = [60,54,48,42,36,30,24,18,12,6 ,0,
                  61,55,49,43,37,31,25,19,13,7 ,1,
                  62,56,50,44,38,32,26,20,14,8 ,2,
                  63,57,51,45,39,33,27,21,15,9 ,3,
                  64,58,52,46,40,34,28,22,16,10,4,
                  65,59,53,47,41,35,29,23,17,11,5]
