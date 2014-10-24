sinon = require('sinon')

class DummyStrategy
  constructor: ->
    @isInherited = true

EveOnlineStrategy = require('../src/strategy-injected-parent.coffee')(DummyStrategy)

describe 'EVE Online OAuth Strategy', ->
  beforeEach ->
    @strategy = new EveOnlineStrategy()
    console.log('is inherited?' + @strategy.isInherited)

  it 'must inherit from passport-oauth2 strategy', ->
    @strategy.isInherited.should.be.true
