# Playfield size
window.ROWS = 11
window.COLS = 6
window.PANELS = ROWS * COLS
#number of starting blocks
window.NRBLOCK = 17
# States
window.STATIC = 0
window.HANG   = 1
window.FALL   = 2
window.SWAP   = 3
window.CLEAR  = 4
# Animation Frame
window.FRAME_LAND    = [4,4,4,2,2,2,3,3,3,0]
window.FRAME_CLEAR   = [6,0,6,0,6,0,6,0,6,0,6,0
                        6,0,6,0,6,0,6,0,6,0,6,0
                        6,0,6,0,6,0,6,0,6,0,6,0
                        6,0,6,0,6,0,6,0,5,5,5,5
                        5,5,5,5,5,5,5,5,5,5,5,5]

window.FRAME_LIVE    = [0]
window.FRAME_DANGER  = [0,4,0,3,2,3]
window.FRAME_DEAD    = [5]
window.FRAME_NEWLINE = [1]

# Animation states
window.ANIM_SWAP_LEFT  = 0
window.ANIM_SWAP_RIGHT = 1
window.ANIM_LAND       = 2
window.ANIM_CLEAR      = 3

# Timing
window.TIME_CLEAR = FRAME_CLEAR.length #the time it takes before the first panel is ready to start popping
window.TIME_POP   = 9                  #when a panel is ready to pop is needs to wait for time_pop before popping
window.TIME_FALL  = 3                  # how long to wait after popping last panel before panel falls


window.HANGTIME         = 11
window.FALLTIME         = 4
window.TIME_SWAP        = 4
window.CLEARPAUSETIME   = 23
window.CLEAREXPLODETIME = 9
window.PUSHTIME         = 1000

window.UNIT = 16
window.WIN_WIDTH  = 434 #256
window.WIN_HEIGHT = 224

window.MENUCURSORBLINK = 12

window.STARTPOS_PANELCURSOR_SPEED = 6


# scan bottom to top, left to right.
# I was too lazy to use math so I wrote out
# the indexes by hand.
window.SCAN_BTLR = [60,54,48,42,36,30,24,18,12,6 ,0,
                    61,55,49,43,37,31,25,19,13,7 ,1,
                    62,56,50,44,38,32,26,20,14,8 ,2,
                    63,57,51,45,39,33,27,21,15,9 ,3,
                    64,58,52,46,40,34,28,22,16,10,4,
                    65,59,53,47,41,35,29,23,17,11,5]
