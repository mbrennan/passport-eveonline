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

      super(options, @_verifyOAuth2)
      @_oauth2.useAuthorizationHeaderforGET(true)

      @name = 'eveonline'

    userProfile: (accessToken, done) ->
      @_oauth2.get(@_verifyURL, accessToken, (error, body, response) =>
          @_parseCharacterInformation(error, body, response, done))

    _verifyOAuth2: (accessToken, refreshToken, characterInformation, done) ->
      @_verifyCallback(characterInformation, done)

    _parseCharacterInformation: (error, body, response, done) ->
      done(new InternalOAuthError(
        constants.fetchCharacterInformationError, error)) if error

      try
        responseBody = JSON.parse body

        return done(new VerificationError(
          responseBody.error,
          responseBody.error_description)) if responseBody.error

        done(null, responseBody)

      catch exception
        done(exception)

  return EveOnlineStrategy
