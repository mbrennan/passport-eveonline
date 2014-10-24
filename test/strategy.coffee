sinon = require('sinon')

class DummyStrategy
  constructor: (_arguments) ->
    @isInherited = true
    @parentConstructor = sinon.spy()
    @parentConstructor.apply(@parentConstructor, _arguments)

EveOnlineStrategy = require('../src/strategy-injected-parent.coffee')(DummyStrategy)

describe 'EVE Online OAuth Strategy', ->
  beforeEach ->
    @strategy = new EveOnlineStrategy()
    console.log('is inherited?' + @strategy.isInherited)

  it "should be named 'eveonline'", ->
    @strategy.name.should.equal 'eveonline'

  it 'must inherit from passport-oauth2 strategy', ->
    @strategy.isInherited.should.be.true

  it "should invoke the base strategy's constructor", ->
    @strategy.parentConstructor.called.should.be.true

