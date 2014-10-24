OAuth2Strategy = require('passport-oauth2')

class EveOnlineStrategy
  constructor: (options, verify) ->
    options ?= {}
    if typeof options == 'function'
      verify = options
      options = {}

    options.oAuth2Strategy ?= OAuth2Strategy

    @name = 'eveonline'
    @oAuth2Strategy = options.oAuth2Strategy
    @oAuth2Strategy(options, verify)

  authenticate: (request, options) ->
    @oAuth2Strategy.authenticate(request, options)


module.exports = EveOnlineStrategy