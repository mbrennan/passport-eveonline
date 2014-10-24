module.exports = (oAuth2Strategy) ->
  class EveOnlineStrategy extends oAuth2Strategy
    constructor: (options) ->
      options ?= new Object()
      options.authorizationURL ?= 'https://login.eveonline.com/oauth/authorize'
      options.tokenURL ?= 'https://login.eveonline.com/oauth/token'
      super(options)

      @name = 'eveonline'

  return EveOnlineStrategy
