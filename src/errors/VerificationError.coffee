class VerificationError extends Error
  constructor: (@code, @description) ->
    super()
    Error.captureStackTrace(@, arguments.callee);
    @name = 'VerificationError';
    code ?= "server_error"
    description ?= "unable to verify login to obtain character information"
    @message = "#{code}: #{description}"

module.exports = VerificationError
