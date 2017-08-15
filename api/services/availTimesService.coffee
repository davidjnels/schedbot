Acuity = require 'acuityscheduling'
config =
  userId: 13277271,
  apiKey: '268ba575326cc2fe94d6b780009bee25'


Array::where = (query) ->
  return [] if typeof query isnt "object"
  hit = Object.keys(query).length
  @filter (item) ->
    match = 0
    for key, value of query
      match += 1 if item[key] is value
    if match is hit then true else false

moment = require 'moment'
dates = dates ? this
#date = new Date()


module.exports =
  getAvailTimes: (auth, options) ->
    acuity = Acuity.basic(auth)
    #console.log options

    return new Promise (resolve, reject) ->
      acuity.request "availability/times?date=#{options.date}&calendarID=#{options.calendarID}&appointmentTypeID=#{options.appointmentTypeID}&timezone=#{options.tz}", (err, response, timesAvail) ->
        times = []
        #console.log timesAvail
        for time in timesAvail
          hour = moment(time.time).format("HH")
          if hour < 12 then time.timeOfDay = 'morning' else time.timeOfDay = 'afternoon'

          times.push
            time: time.time
            timeFriendly: moment(time.time).format('h:mma')
            timeOfDay: time.timeOfDay





        goodTimes =
          timePref: options.timePref
          times: times
          day: options.day
        console.log goodTimes
        JSON.stringify goodTimes
        #console.log goodTimes
        success = true
        if success
          resolve goodTimes
        else
          reject Error, err





#auth =
#  userId: 13277271,
#  apiKey: '3d97f0676ab38e48d902d8c7cd138855'
#getAvailTimes(auth,
#  options =
#    appointmentTypeID: 2563498
#    date: '2017-03-14T13:00:00-0500'
#    calendarID: 1024257
#    tz:'America/New_York'
#).then (times) -> console.log times
###bb = moment('2017-03-14T10:30:00-0400').format("HH")
isM = ''
if bb < 12 then isM = 'morning' else isM = 'afternoon'
console.log isM###
