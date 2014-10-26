constants           = require './constants'
InternalOAuthError  = require('passport-oauth2').InternalOAuthError

module.exports = (oAuth2Strategy) ->
  class EveOnlineStrategy extends oAuth2Strategy
    constructor: (options, @_verifyCallback) ->
      if not options or not options.callbackURL
        throw new TypeError('EveOnlineStrategy requires a callbackURL option')

      options ?= new Object()

      options.authorizationURL ?= constants.defaultAuthorizationURL
      options.tokenURL ?= constants.defaultTokenURL
      options.verifyURL ?= constants.defaultVerifyURL
      @_verifyURL = options.verifyURL

      console.log("building new passport-eveonline strategy with options:")
      console.log(options)
      super(options, @_verifyOAuth2)

      @name = 'eveonline'

    userProfile: (accessToken, done) ->
      console.log("userProfile invoked, invoking _oauth2 with access token #{accessToken}...")
      @_oauth2.get(@_verifyURL, accessToken, @_parseCharacterInformation(done))

    _verifyOAuth2: (accessToken, refreshToken, characterInformation, done) ->
      console.log("_verifyOAuth2 invoked, accessToken #{accessToken}, refresh token #{refreshToken}, character info #{JSON.stringify(characterInformation)} ")
      @_verifyCallback(characterInformation, done)

    _parseCharacterInformation: (done) ->
      return (error, body, response) ->
        console.log("parsing character info")
        done(new InternalOAuthError(
          constants.fetchCharacterInformationError, error)) if error

        console.log("no error, body is #{body}")
        console.log("response code is #{response.statusCode}") if response

        try
          responseBody = JSON.parse body

          if responseBody.error
            errorMessage = responseBody.error_description \
              if responseBody.error_description
            errorMessage ?= 'Unable to obtain character information'
            return done(new InternalOAuthError(
              errorMessage,
              responseBody.error))

          characterInformation =
            characterID:        responseBody.CharacterID
            characterName:      responseBody.CharacterName
            expiresOn:          responseBody.ExpiresOn
            scopes:             responseBody.Scopes
            tokenType:          responseBody.TokenType
            characterOwnerHash: responseBody.CharacterOwnerHash

          done(null, characterInformation)

        catch exception
          done(exception)

  return EveOnlineStrategy
