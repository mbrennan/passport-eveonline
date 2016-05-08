class VerificationError extends Error
  constructor: (@code, @description) ->
    super()
    code = ""
    description = ""
    Error.captureStackTrace(@, arguments.callee);
    @name = 'VerificationError';
    code ?= "server_error"
    description ?= "unable to verify login to obtain character information"
    @message = "#{code}: #{description}"

module.exports = VerificationError
