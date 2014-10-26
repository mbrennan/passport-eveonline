constants           = require './constants'
InternalOAuthError  = require('passport-oauth2').InternalOAuthError

module.exports = (oAuth2Strategy) ->
  class EveOnlineStrategy extends oAuth2Strategy
    constructor: (options, @_verify) ->
      if not options or not options.callbackURL
        throw new TypeError('EveOnlineStrategy requires a callbackURL option')

      options ?= new Object()

      options.authorizationURL ?= constants.defaultAuthorizationURL
      console.log options.authorizationURL
      options.tokenURL ?= constants.defaultTokenURL

      super(options, @_verifyOAuth2)

      @name = 'eveonline'

    userProfile: (accessToken, done) ->
      @_oauth2.get(
        constants.defaultVerifyURL,
        accessToken,
        @_parseCharacterInformation(done))

    _verifyOAuth2: (accessToken, refreshToken, characterInformation, done) ->
      @_verify(characterInformation, done)

    _parseCharacterInformation: (done) ->
      return (error, body, response) ->
        done(new InternalOAuthError(
          constants.fetchCharacterInformationError, error)) if error

        try
          responseBody = JSON.parse body

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
