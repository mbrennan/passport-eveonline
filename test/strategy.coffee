constants = require('../src/constants')
sinon = require('sinon')
should = require('should')

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
      @oAuth2Get = @strategy._oauth2.get.args[0]
      @oAuth2GetCallback = @oAuth2Get[2]

    it 'should fetch character information using the protected _oauth2
        object', ->
      @oAuth2Get[0].should.be.a.String
      @oAuth2Get[1].should.equal @accessToken
      @oAuth2GetCallback.should.be.a.Function

    describe 'when called back with character information', ->
      beforeEach ->
        @expectedProfile =
          CharacterID: 54321
          CharacterName: 'Kooky Kira'
          ExpiresOn: 'Some Expiration Date'
          Scopes: 'some scopes'
          TokenType: 'Character'
          CharacterOwnerHash: 'beefdeadbad'

        @oAuth2GetCallback(null, JSON.stringify(@expectedProfile), null)
        @characterInformation = @userProfileCallback.args[0][1]

      it 'should not return an error', ->
        should.not.exist @userProfileCallback.args[0][0]

      it 'should find the character id', ->
        @characterInformation.characterID.should.equal \
          @expectedProfile.CharacterID

      it 'should find the character name', ->
        @characterInformation.characterName.should.equal \
          @expectedProfile.CharacterName

      it 'should find the expires on field', ->
        @characterInformation.expiresOn.should.equal @expectedProfile.ExpiresOn

      it 'should find the scopes field', ->
        @characterInformation.scopes.should.equal @expectedProfile.Scopes

      it 'should find the token type', ->
        @characterInformation.tokenType.should.equal @expectedProfile.TokenType

      it 'should find the character owner hash', ->
        @characterInformation.characterOwnerHash.should.equal \
          @expectedProfile.CharacterOwnerHash

    describe 'when callbed back with a mal-formed JSON body', ->
      beforeEach ->
        @oAuth2GetCallback(null, 'a bad body', null)
        @error = @userProfileCallback.args[0][0]

      it 'should catch exceptions and callback with an error', ->
          @error.should.be.ok

    describe 'when called back with an error', ->
      beforeEach ->
        @innerError = new Error('some error')
        @oAuth2GetCallback(@innerError)
        @error = @userProfileCallback.args[0][0]

      it 'should callback with an InternalOAuthError', ->
        @error.name.should.equal 'InternalOAuthError'
        @error.message.should.equal constants.fetchCharacterInformationError
        @error.oauthError.should.equal @innerError

