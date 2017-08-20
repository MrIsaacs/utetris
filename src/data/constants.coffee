# Playfield size
window.ROWS = 12
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
# Animation states
window.ANIM_SWAP_LEFT  = 0
window.ANIM_SWAP_RIGHT = 1
window.ANIM_LAND       = 2
window.ANIM_CLEAR      = 4
# Timing
window.HANGTIME         = 11
window.FALLTIME         = 4
window.SWAPTIME         = 4
window.CLEARBLINKTIME   = 44
window.CLEARPAUSETIME   = 23
window.CLEAREXPLODETIME = 9
window.PUSHTIME         = 1000

window.UNIT = 16
window.WIN_WIDTH  = 434 #256
window.WIN_HEIGHT = 224

window.MENUCURSORBLINK = 12

# Animation timing - These aren't being used
window.ANIM_SWAPTIME       = 4
window.ANIM_LANDTIME       = 0
window.ANIM_CLEARBLINKTIME = 15
window.ANIM_DANGERTIME     = 6
