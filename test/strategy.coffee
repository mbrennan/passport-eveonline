sinon = require('sinon')
EveOnlineStrategy = require('../src/')

class DummyStrategy
  constructor: (args...) ->
    @authenticate = sinon.spy()
    @constructor = sinon.spy()
    @constructor.apply(@constructor, args)

describe 'EVE Online OAuth Strategy', ->
  beforeEach ->
    @clientID = 12345;
    @clientSecret = 'deadbeefbaadf00d'

    @strategyOptions =
      clientID: @clientID
      clientSecret: @clientSecret
      oAuth2Strategy: DummyStrategy
    @verify = ->

    @strategy = new EveOnlineStrategy(@strategyOptions, @verify)
    @oAuth2Strategy = @strategy._oAuth2Strategy
    @constructorOptions = @oAuth2Strategy.constructor.args[0][0]

  it "should be named 'eveonline'", ->
    @strategy.name.should.equal 'eveonline'

  describe 'when constructing', ->
    it "should invoke passport-oAuth2 strategy's constructor", ->
      @oAuth2Strategy.constructor.called.should.be.true

    it "should construct a new instance of the passport-oauth2 strategy", ->
      @oAuth2Strategy.should.be.type('object')

    it "should pass authorizationURL to passport-oauth2 strategy's \
       constructor", ->
      @constructorOptions.should.have.property('authorizationURL')

    it "should pass tokenURL to passport-oauth2 strategy's constructor", ->
      @constructorOptions.should.have.property('tokenURL')

    it "should pass clientID to passport-oauth2 strategy's constructor", ->
      @constructorOptions.should.have.property('clientID').equal @clientID

    it "should pass clientSecret to passport-oauth2 strategy's constructor", ->
      @constructorOptions.should.have.property(
        'clientSecret').equal @clientSecret

  describe 'when authenticating', ->
    beforeEach ->
      @request = ' request'
      @authenticateOptions = {some: 'options'}
      @strategy.authenticate(@request, @authenticateOptions)

    it "should invoke passport-oauth2 strategy's authenticate function", ->
      @oAuth2Strategy.authenticate.calledWith(
        @request, @authenticateOptions).should.be.true

    it 'should set the context to the same context it was called on', ->
      @oAuth2Strategy.authenticate.calledOn(@oAuth2Strategy)

