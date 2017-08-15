###


moment = require 'moment'


Acuity = require 'acuityscheduling'

module.exports =


  getAll: (auth, options) ->

    @email = options.email
    @now = moment()

    if @email is 'foo' then ->

      acuity.request "appointments"


###
