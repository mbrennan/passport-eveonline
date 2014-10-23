sinon = require('sinon')
EveOnlineStrategy = require('../src/')
OAuth2Strategy = require('passport-oauth2')

describe 'EVE Online OAuth Strategy', ->
  before ->
    @strategyOptions = {some: 'options'}
    @strategy = new EveOnlineStrategy
    @verify = ->

  it "should be named 'eveonline'", ->
    @strategy.name.should.equal 'eveonline'

  describe 'when authenticating', ->
    beforeEach ->
      @authenticate = sinon.stub(OAuth2Strategy.prototype, 'authenticate')
      @request = ' request'
      @strategy.authenticate(@request, @options)

    afterEach ->
      @authenticate.restore

    it "should invoke passport-oauth2 strategy's authenticate function", ->
      @authenticate.calledWith(@request, @options).should.be.true
