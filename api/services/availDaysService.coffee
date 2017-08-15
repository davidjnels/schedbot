Acuity = require 'acuityscheduling'
config =
  userId: 13277271,
  apiKey: '268ba575326cc2fe94d6b780009bee25'

moment = require 'moment'
dates = dates ? this
date = new Date()

nextWeek = moment(date).add(7, 'days').format("YYYY-MM-DD")

module.exports =
  getAvailDays: (auth, options) ->
    console.log 'OPTIONS':options
    #console.log "the date is #{options.date}""
    acuity = Acuity.basic(auth)
#    today = moment(date).format("YYYY-MM-DD")
    month = options.date
    apptTypeID = options.apptTypeId
    tz = options.tz
    calId = options.calId
    #console.log options

    return new Promise (resolve, reject) ->
      acuity.request "availability/dates?appointmentTypeID=#{apptTypeID}&month=#{month}&calendarID=#{calId}&timezone=#{tz}", (err, response, datesAvail) ->
        dates = []
        console.log datesAvail
        for d in datesAvail
          dates.push
            date: d.date
            dateFriendly: moment(d.date).calendar(null,
              sameDay: '[Today]'
              nextDay: '[Tomorrow]'
              nextWeek:'MMMM Do'
              sameElse:'MMMM Do'
              )

        if dates.length > 4 then dates.length = 5
        console.log 'DATES':dates
        responseJSON =
          response: "Here's what we have available over the next week..."
          continue: true
          customPayload: options.apptTypeId
          quickReplies: d.dateFriendly for d in dates
          customVars: "apptTypeID": apptTypeID.toString()

        JSON.stringify responseJSON

        console.log responseJSON
        success = true
        if success
          resolve responseJSON
        else
          reject Error err





