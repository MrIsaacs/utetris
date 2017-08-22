{ROWS} = require '../src/data/constants'
{Panel} = require '../src/components/panel'

Component =
  Panel: Panel

chai = require 'chai'
chai.should()

CoffeeScript = require('coffee-script')
require("coffee-script/register")
CoffeeScript.register()

describe 'Panel', ->
  panel = null
  it 'should have danger set to false', ->
    panel = new Component.Panel()
    panel.create()
    console.log 'ppp', panel.danger
    panel.danger.should.equal false
