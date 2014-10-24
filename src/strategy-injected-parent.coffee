module.exports = (oAuth2Strategy) ->
  class EveOnlineStrategy extends oAuth2Strategy
    constructor: ->
      super()
      @name = 'eveonline'

  return EveOnlineStrategy
