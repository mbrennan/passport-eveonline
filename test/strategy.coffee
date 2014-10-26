sinon = require('sinon')

class DummyOAuth2
  constructor: ->
    @get = sinon.spy()

class DummyStrategy
  constructor: (_arguments...) ->
    @isInherited = true

    @parentConstructor = sinon.spy()
    @parentConstructor.apply(this, _arguments)

    @parentAuthenticate = sinon.spy()
    @_oauth2 = new DummyOAuth2()

  authenticate: (_arguments...) ->
    @parentAuthenticate.apply(this, _arguments)


EveOnlineStrategy = require('../src/strategy')(DummyStrategy)

describe 'EVE Online OAuth Strategy', ->
  beforeEach ->
    @clientID = 12345
    @clientSecret = 'deadbeefbaadf00d'
    @callbackURL = 'https://dead.beef/bad/f00d'
    @verify = sinon.spy()
    @strategy = new EveOnlineStrategy(
      clientID: @clientID
      clientSecret: @clientSecret,
      callbackURL: @callbackURL
      @verify)
    @constructorOptions = @strategy.parentConstructor.args[0][0]
    @oAuth2Verify = @strategy.parentConstructor.args[0][1]

  it "should be named 'eveonline'", ->
    @strategy.name.should.equal 'eveonline'

  it 'must inherit from passport-oauth2 strategy', ->
    @strategy.isInherited.should.be.true

  describe 'when constructing', ->
    it 'should invoke the base strategy constructor', ->
      @strategy.parentConstructor.called.should.be.true

    it 'should pass authorizationURL to the base strategy constructor', ->
      @constructorOptions.should.have.property('authorizationURL')

    it 'should pass tokenURL to the base strategy constructor', ->
      @constructorOptions.should.have.property('tokenURL')

    it 'should pass clientID to the base strategy constructor', ->
      @constructorOptions.should.have.property('clientID').equal @clientID

    it 'should pass clientSecret to the base strategy constructor', ->
      @constructorOptions.should.have.property(
        'clientSecret').equal @clientSecret

    it 'should pass callbackURL to the base strategy constructor', ->
      @constructorOptions.should.have.property('callbackURL').equal @callbackURL

    it 'should pass a verify function to the base strategy constructor', ->
      @oAuth2Verify.should.be.a.Function


  describe 'when constructing without a callbackURL', ->
    it 'should throw an exception', ->
      (->
        new EveOnlineStrategy(
          clientID: @clientID
          clientSecret: @clientSecret,
          @verify)
      ).should.throw()

  describe 'when authenticating', ->
    beforeEach ->
      @request = 'request'
      @authenticateOptions = {some: 'options'}
      @strategy.authenticate(@request, @authenticateOptions)

    it 'should invoke the base authenticate function', ->
      @strategy.parentAuthenticate.calledWith(
        @request, @authenticateOptions).should.be.true

  describe 'when verifying', ->
    beforeEach ->
      @oAuth2VerifyDone = 'done callback'
      @profile = 'profile'
      @oAuth2Verify.call(
        @strategy,
        'access token',
        'refresh token',
        @profile,
        @oAuth2VerifyDone)

    it 'translates passport-oauth2 verifications', ->
      @verify.calledWith(@profile, @oAuth2VerifyDone).should.be.true

  describe 'when building character information', ->
    beforeEach ->
      @accessToken = 'deadbeef'
      @userProfileCallback = sinon.spy()
      @strategy.userProfile(@accessToken, @userProfileCallback)
      @oAuth2FunctionCall = @strategy._oauth2.get.args[0]

    it 'should fetch character information using the protected _oauth2
        object', ->
      @oAuth2FunctionCall[0].should.be.a.String
      @oAuth2FunctionCall[1].should.equal @accessToken
      @oAuth2FunctionCall[2].should.be.a.Function

    describe 'when called back with response containing character
              information', ->
      beforeEach ->
        @expectedProfile = null

      it 'should callback when complete', ->
        @userProfileCallback.calledWith(null, @expectedProfile).should.be.true


