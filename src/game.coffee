#window._d      = new Core.Data()
window.game    = new Phaser.Game _rez.w, _rez.h, Phaser.AUTO, 'phaser-example'
game.state.add 'boot' , _states.boot
game.state.add 'load' , _states.load
game.state.add 'menu' , _states.menu

game.state.add 'single_player', _states.single_player
game.state.start 'boot'
