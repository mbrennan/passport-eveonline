sinon = require('sinon')
EveOnlineStrategy = require('../src/')
OAuth2Strategy = require('passport-oauth2')

describe 'Strategy', ->
  before ->
    @strategy = new EveOnlineStrategy()

  it "should be named 'eveonline'", ->
    @strategy.name.should.equal 'eveonline'

  describe 'when authenticating', ->
    before ->
      @authenticate = sinon.stub(OAuth2Strategy.prototype, 'authenticate')
      @request = ' request'
      @options = {some: 'options'}
      @strategy.authenticate(@request, @options)

    it "should invoke passport-oauth2 strategy's authenticate function", ->
      @authenticate.calledWith(@request, @options).should.be.true
