gulp   = require 'gulp'
coffee = require 'gulp-coffee'
concat = require 'gulp-concat'
addsrc = require 'gulp-add-src'
uglify = require 'gulp-uglify'

ug_opts =
  compress: true
  mangle: true

js_init  = './src/init.js'

js_lib  = [
  "./src/lib/lodash.js"
  "./src/lib/phaser.js"
  ]

js_app = [
  './src/data/constants.coffee'
  './src/core/controls.coffee'
  './src/core/data.coffee'
  './src/core/rez.coffee'
  './src/core/filters.coffee'


  './src/components/ai.coffee'

  './src/components/menu.coffee'
  './src/components/menu_cursor.coffee'

  './src/components/menu_pause.coffee'
  './src/components/menu_pause_cursor.coffee'

  './src/components/playfield.coffee'
  './src/components/playfield_cursor.coffee'

  './src/components/panel.coffee'
  './src/components/score.coffee'

  './src/states/boot.coffee'
  './src/states/load.coffee'
  './src/states/menu.coffee'

  './src/states/mode_1p_vs_cpu.coffee'
  './src/states/mode_puzzle.coffee'

  './src/game.coffee'
  ]

gulp.task 'js', ->
  gulp.src(js_app)
    .pipe(coffee())
    .pipe(addsrc.prepend(js_lib))
    .pipe(addsrc.prepend(js_init))
    #.pipe(uglify(ug_opts))
    .pipe(concat('app.js'))
    .pipe gulp.dest('./public/')

gulp.task 'default', ->
  gulp.run 'js'
  return

gulp.task 'watch', ->
  gulp.watch [
    './src/init.js'
    './src/**/*.coffee'
  ], [ 'js' ]
  return
