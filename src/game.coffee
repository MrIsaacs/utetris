window._d      = new Core.Data()
window.game    = new Phaser.Game WIN_WIDTH, WIN_HEIGHT, Phaser.AUTO, 'phaser-example'
game.state.add 'boot' , _states.boot
game.state.add 'load' , _states.load
game.state.add 'menu' , _states.menu

game.state.add 'mode_1p_vs_cpu', _states.mode_1p_vs_cpu
game.state.add 'mode_puzzle'   , _states.mode_puzzle
game.state.start 'boot'
