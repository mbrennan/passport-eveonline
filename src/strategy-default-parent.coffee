OAuth2Strategy = require('passport-oauth2')
EveOnlineStrategyWithInjectedParent =
  require('./strategy-injected-parent.coffee')(OAUth2Strategy)

module.exports = EveOnlineStrategyWithInjectedParent
