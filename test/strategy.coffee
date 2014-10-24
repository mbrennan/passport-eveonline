sinon = require('sinon')

class DummyStrategy
  constructor: (_arguments...) ->
    @isInherited = true
    @parentConstructor = sinon.spy()
    @parentConstructor.apply(@parentConstructor, _arguments)

EveOnlineStrategy = require('../src/strategy.coffee')(DummyStrategy)

describe 'EVE Online OAuth Strategy', ->
  beforeEach ->
    @strategy = new EveOnlineStrategy()
    @constructorOptions = @strategy.parentConstructor.args[0][0]

  it "should be named 'eveonline'", ->
    @strategy.name.should.equal 'eveonline'

  it 'must inherit from passport-oauth2 strategy', ->
    @strategy.isInherited.should.be.true

  describe 'when constructing', ->
    it 'should invoke the base strategy constructor', ->
      @strategy.parentConstructor.called.should.be.true

    it 'should pass authorizationURL to the base strategy constructor', ->
      @constructorOptions.should.have.property('authorizationURL')

