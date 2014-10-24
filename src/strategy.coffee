module.exports = (oAuth2Strategy) ->
  class EveOnlineStrategy extends oAuth2Strategy
    constructor: (options, verify) ->
      options ?= new Object()

      if typeof(options) is 'function'
        verify = options
        options = new Object()

      options.authorizationURL ?= 'https://login.eveonline.com/oauth/authorize'
      options.tokenURL ?= 'https://login.eveonline.com/oauth/token'
      super(options, verify)

      @name = 'eveonline'

  return EveOnlineStrategy
