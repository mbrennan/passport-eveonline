InternalOAuthError  = require('passport-oauth2').InternalOAuthError
constants           = require './constants'
VerificationError   = require './errors/VerificationError'

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
      @_oauth2.get(@_verifyURL, accessToken, (error, body, response) =>
          @_parseCharacterInformation(error, body, response, done))

    _verifyOAuth2: (accessToken, refreshToken, characterInformation, done) ->
      console.log("_verifyOAuth2 invoked, accessToken #{accessToken}, refresh token #{refreshToken}, character info #{JSON.stringify(characterInformation)} ")
      @_verifyCallback(characterInformation, done)

    _parseCharacterInformation: (error, body, response, done) ->
      console.log("parsing character info")
      done(new InternalOAuthError(
        constants.fetchCharacterInformationError, error)) if error

      console.log("no error, body is #{body}")
      console.log("response code is #{response.statusCode}") if response

      try
        responseBody = JSON.parse body

        return done(new VerificationError(
          responseBody.error,
          responseBody.error_description)) if responseBody.error

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
