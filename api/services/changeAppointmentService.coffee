Acuity = require 'acuityscheduling'
local = require '../../config/local'
formatMsg = require './formatApptMessageService'

moment = require 'moment'
_ = require 'underscore'
today = moment().format()
Array::where = (query) ->
  return [] if typeof query isnt "object"
  hit = Object.keys(query).length
  @filter (item) ->
    match = 0
    for key, value of query
      match += 1 if item[key] is value
    if match is hit then true else false

Q = (ids, auth) -> findByMultipleIds(ids, auth)

findById = (id, auth) ->
  acuity = Acuity.basic(auth)
  #console.log id.length
  return new Promise (resolve, reject) ->
    acuity.request "appointments/#{id}", (err, response, appointment) ->
      appointment

      success = true

      if success
        resolve appointment
      else reject Error, err


findByEmail = (email, auth) ->
  console.log email

  console.log today
  acuity = Acuity.basic(auth)
  capitalized = (email) -> email[0].toUpperCase() + email.substr(1)
  capEmail = capitalized(email)
  return new Promise (resolve, reject) ->
    acuity.request "appointments", (err, response, appointments) ->

      appts = []

      appointmentId = (appointments) ->
        for appointment in appointments

          if appointment.email is capEmail
            appts.push appointment.id
          else if appointment.email is email
            appts.push appointment.id
          else
            'none found'

      appointmentId(appointments)
      #console.log appts
      success = true
      if success
        resolve appts
      else reject Error, err



findByMultipleIds = (apptIds, auth) ->
  appts = []
  index = 0
  apptIds.forEach (ids) ->
    #console.log "the #{ids}"
    appts.push ((ids) ->
      return new Promise (
        (resolve, reject) ->
          findById(ids, auth).then (appt) ->

            appt

            success = true
            if success
              resolve appt
            else reject Error,  err
      ))(ids, index++)
    return
  Promise.all appts
#console.log appts

type = 'email'

auth =
  userId: 13277271,
  apiKey: '268ba575326cc2fe94d6b780009bee25'


findAppointment = (options, auth) ->
  return new Promise (resolve, reject) ->
    console.log options
    opts = {}
    theAppt = []
    useEmail = false
    if options.type is 'email'
      useEmail = true
      email = options.email
      options.id?  false
      opts.email = email
      console.log opts
    else
      console.log 'ok'
    if options.type is 'id'
      opts.id = options.id
      console.log opts

    if useEmail is true
      foo = (opts, auth)->
        return new Promise (resolve, reject) ->
          findByEmail(opts.email, auth).then (ids) -> Q(ids, auth).then (appts) ->
            for appt in appts
              theAppt.push appt

            success = true
            if success
              resolve theAppt

            else
              reject Error, err
      foo(opts, auth).then (theAppt) ->
        Promise.resolve(theAppt)
        #console.log theAppt

        success = true
        if success
          resolve theAppt
          #console.log theAppt
        else
          reject Error, err

    else
      console.log "it's an id"
      useId = (opts, auth) ->
        return new Promise (resolve, reject) ->
          findById(opts.id, auth).then (appts) ->
            appts
            success = true
            if success
              resolve appts
            else
              reject Error, err
      useId(opts, auth).then (appt) ->
        Promise.resolve(appt)
        theAppt.push appt
        success = true
        if success
          resolve theAppt

        else
          reject Error, err


cancelAppointment = (apptId, auth) ->
  console.log apptId
  acuity = Acuity.basic(auth)
  options =
    method: 'PUT'
  uri = "/appointments/#{apptId}/cancel"
  console.log uri
  return new Promise (resolve, reject) ->
    acuity.request uri,options, (err, res, appointment) ->
      console.log appointment


      success = true
      if success
        resolve appointment
      else
        reject Error, err


changeAppointment = (options, auth) ->
  acuity = Acuity.basic(auth)
  console.log options
  datetime = options.dt
  #calendarId = options.calId

  opts =
    method:'PUT'
    body:
      datetime: datetime

  uri = "/appointments/#{options.id}/reschedule"

  return new Promise (resolve, reject) ->
    acuity.request uri, opts, (err, res, appointment) ->
      if err then console.log err
      console.log appointment

      success = true
      if success
        resolve appointment
      else
        reject Error, console.log err

module.exports =
  change: (options, auth) ->
    changeAppointment(options, auth).then (appt) -> appt


  cancel: (apptId, auth) ->
    cancelAppointment(apptId, auth).then (results) ->
      if results.error?
        console.log results
        results =
          apptStatus:'not_cancelled'
          appt:"Oops! We have a bit of a problem..."
          error:results.error
          message: results.message
         #if appt.message? then results.message = appt.message else results.message = 'none'
      else
        results.apptStatus = "cancelled"
        #results.appt = results
      return results

  find: (options, auth) ->
    findAppointment(options, auth).then (results) ->
      if results[0].error?
        results = results:'nothing found check email or id'
      else
        console.log results
        apptArray = (results) ->
          results.reduce (x,y) ->
            x[moment(y.datetime).format("MMMM DD")] = y.id
            x
          , {}
        console.log JSON.stringify apptArray(results)
        results =
          foundAppointments: if results.length >0 then true else false
          howMany: results.length
          idPayload:apptArray(results)
          simpleResults:
            for result in results
              firstName: result.firstName
              lastName: result.lastName
              id: result.id
              date: result.date
              time: result.time
              datetime: result.datetime
              type:result.type
              calender:result.calendar
          results:results







###email = "brian@wynkk.co"
id = 89736325###
###auth =
  userId: 13277271,
  apiKey: '3d97f0676ab38e48d902d8c7cd138855'###


auth = local.auth
###options =
  type: 'email'
  email: 'brian@wynkk.co'
  id:89736325

find(options, auth).then (results) -> console.log results###
###findAppointment(options, auth).then (results) ->

  console.log results =
    foundAppointments: if results.length >0 then true else false
    howMany: results.length
    simpleResults:
      for result in results
        firstName: result.firstName
        lastName: result.lastName
        id: result.id
        date: result.date
        time: result.time
        datetime: result.datetime
        type:result.type
        calender:result.calendar
    results:results###

