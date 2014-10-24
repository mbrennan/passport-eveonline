OAuth2Strategy = require('passport-oauth2')

class EveOnlineStrategy
  constructor: (options, verify) ->
    options ?= {}
    if typeof options == 'function'
      verify = options
      options = {}

    options.oAuth2Strategy ?= OAuth2Strategy
    options.authorizationURL ?= 'https://login.eveonline.com/oauth/authorize'
    options.tokenURL ?= 'https://login.eveonline.com/oauth/token'

    @_oAuth2Strategy = new options.oAuth2Strategy(options, verify)
    @name = 'eveonline'

  authenticate: (request, options) ->
    @_oAuth2Strategy.authenticate(request, options)


module.exports = EveOnlineStrategy