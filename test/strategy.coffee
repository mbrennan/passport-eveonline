sinon = require('sinon')
EveOnlineStrategy = require('../src/')
OAuth2Strategy = require('passport-oauth2')

describe 'EVE Online OAuth Strategy', ->
  beforeEach ->
    @oAuth2Strategy = sinon.spy()
    @oAuth2Strategy['authenticate'] = sinon.spy()
    @clientID = 12345;
    @clientSecret = 'deadbeefbaadf00d'

    @strategyOptions =
      clientID: @clientID
      clientSecret: @clientSecret
      oAuth2Strategy: @oAuth2Strategy
    @verify = ->

    @strategy = new EveOnlineStrategy(@strategyOptions, @verify)
    @constructorOptions = @oAuth2Strategy.args[0][0]

  it "should be named 'eveonline'", ->
    @strategy.name.should.equal 'eveonline'

  describe 'when constructing', ->
    it "should invoke passport-oAuth2 strategy's constructor", ->
      @oAuth2Strategy.called.should.be.true

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
