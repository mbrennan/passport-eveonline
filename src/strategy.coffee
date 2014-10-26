module.exports = (oAuth2Strategy) ->
  class EveOnlineStrategy extends oAuth2Strategy
    constructor: (options, @_verify) ->

      if not options or not options.callbackURL
        throw new TypeError('EveOnlineStrategy requires a callbackURL option')

      options ?= new Object()

      options.authorizationURL ?=
        'https://sisilogin.testeveonline.com/oauth/authorize'
      options.tokenURL ?=
        'https://sisilogin.testeveonline.com/oauth/token'

      super(options, @_verifyOAuth2)

      @name = 'eveonline'

    userProfile: (accessToken, done) ->
      @_oauth2.get('', accessToken, @_parseCharacterInformation(done))

    _verifyOAuth2: (accessToken, refreshToken, characterInformation, done) ->
      @_verify(characterInformation, done)

    _parseCharacterInformation: (done) ->
      return (error, body, response) ->
        done(null, null)

  return EveOnlineStrategy
