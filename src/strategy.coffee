module.exports = (oAuth2Strategy) ->
  class EveOnlineStrategy extends oAuth2Strategy
    constructor: (options, verify) ->
      if not options or not options.callbackURL
        throw new TypeError('EveOnlineStrategy requires a callbackURL option')

      options ?= new Object()

      options.authorizationURL ?= 'https://login.eveonline.com/oauth/authorize'
      options.tokenURL ?= 'https://login.eveonline.com/oauth/token'
      super(options, verify)

      @name = 'eveonline'

  return EveOnlineStrategy
