moment = require 'moment'
moment.tz = require 'moment-timezone'

module.exports =
  adjustOffset: (date, tz) ->
    @date = moment(date).format()
    @tz = tz
    @datefix = moment(@date).tz(@tz).format()


