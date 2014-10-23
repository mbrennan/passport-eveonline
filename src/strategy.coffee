OAuth2Strategy = require('passport-oauth2')

class EveOnlineStrategy extends OAuth2Strategy
  constructor: () ->
    @name = 'eveonline'

module.exports = EveOnlineStrategy