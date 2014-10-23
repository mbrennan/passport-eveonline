OAuth2Strategy = require('passport-oauth2')
EveOnlineStrategyWithInjectedParent =
  require('./strategy')(OAuth2Strategy)

module.exports = EveOnlineStrategyWithInjectedParent
