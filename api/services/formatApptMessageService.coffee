rp = require 'request-promise'
shortLink = require './shortLink'
apptTypes = require './apptTypesService'
_ = require 'underscore'
getDays = require './availDaysService'

getTimes = require './availTimesService'

Array::where = (query) ->
  return [] if typeof query isnt "object"
  hit = Object.keys(query).length
  @filter (item) ->
    match = 0
    for key, value of query
      match += 1 if item[key] is value
    if match is hit then true else false

unless Array::filter
  Array::filter = (callback) ->
    element for element in this when callback(element)

#Array::toDict = (key) ->
#  @reduce ((dict, obj) -> dict[ obj[key] ] = obj if obj[key]?; return dict), {}

module.exports =
  formatApptResponse: (appt) ->
    return new Promise (resolve, reject) ->
#console.log appt
      shortLink.short(appt.confirmationPage).then (data) ->
        id = appt.id
        firstName = appt.firstName
        start = appt.time
        #day = appt.day
        date = appt.date
        confirmationPage = data
        type = appt.type

        responseJSON =
          response: ""
          continue: true
          customPayload: ""
          quickReplies: ["okay"]
          cards: null
        responseString = "Ok #{firstName}, your're all set! Here's your appointment ID #{id}::next-2000::You're booked for a #{type} on #{date} at #{start}.::next-2000::Here's a link to you confirmation page - #{confirmationPage}.::next-1800::Just so you know, you can always change your appointment, either on your confirmation page, or by sending me a message that says \"change my appointment\"!"

        if appt is 'not_avail' then responseJSON.response = "Sorry about this, but there isn't a slot available then. Do you want to try a different time?" else responseJSON.response = responseString

        if responseJSON.response isnt responseString then responseJSON.quickReplies = ["yes", "no"]
        console.log responseJSON
        responseJSON.customVars =
          appointmentId:id
          apptDay:appt.date
          apptType:appt.type
          apptTime:appt.time
          apptDateTime:appt.datetime
          apptStatus:"booked"
        success = true
        if success
          resolve responseJSON
        else reject Error, err


  webhookApptResponse: (appt) ->
    return new Promise (resolve, reject) ->
#console.log appt
      shortLink.short(appt.confirmationPage).then (data) ->
        id = appt.id
        firstName = appt.firstName
        start = appt.time
        #day = appt.day
        date = appt.date
        confirmationPage = data
        type = appt.type

        responseJSON =
          response: ""
          continue: true
          customPayload: ""
          quickReplies: ["okay"]
          cards: null
        responseString = "Ok #{firstName}, your're all set! Here's your appointment ID #{id}::next-2000::You're booked for a #{type} on #{date} at #{start}.::next-2000::Here's a link to you confirmation page - #{confirmationPage}.::next-1800::Just so you know, you can always change your appointment, either on your confirmation page, or by sending me a message that says \"change my appointment\"!"

        if appt is 'not_avail' then responseJSON.response = "Sorry about this, but there isn't a slot available then. Do you want to try a different time?" else responseJSON.response = responseString

        if responseJSON.response isnt responseString then responseJSON.quickReplies = ["yes", "no"]
        console.log responseJSON

        success = true
        if success
          resolve responseJSON
        else reject Error, err

  typesResponse: (auth) ->
    return new Promise (resolve, reject) ->
      apptTypes.get(auth).then (data) ->
        console.log data
        responseJSON =
          response: "What kind of appointment do you want to book?"
          continue: false
          customPayload: ""
          quickReplies: d.name for d in data
          cards: null

        ###for d in data
          responseJSON.push customPayload: d.id###
        console.log responseJSON
        success = true
        if success
          resolve responseJSON
        else reject Error, err

  getApptTypeId: (auth, options) ->
#console.log options
    return new Promise (resolve, reject) ->
      apptTypes.get(auth).then (data) ->
        apptId = ''
        for dat in data
          dn = dat.name
          console.log dat.name
          if options.apptTypeName is dn then apptId = dat.id
        options.apptTypeId = apptId

        console.log options
        success = true
        if success
          resolve options
        else
          reject Error, err

  timesResponse: (auth, options) ->
    return new Promise (resolve, reject) ->
      console.log options
      getTimes.getAvailTimes(auth, options).then (goodTimes) ->


        console.log goodTimes
        pref = goodTimes.timePref
        timeArr = goodTimes.times
        goodtimes = (time for time in timeArr when time.timeOfDay is pref)

        response = if goodtimes.length > 0 then "here's what we've got available. Any of these work for you?" else "hmmm... I didn't find anything available. Do you want to check a different day?"

        console.log goodtimes

        #console.log goodtimes
        responseJSON =
          response: response
          continue: true
          customPayload: ""
          quickReplies: time.timeFriendly for time in goodtimes
          cards: null

        responseJSON.customVars = day:goodTimes.day

        success = true
        if success
          resolve responseJSON
        else
          reject Error, err




