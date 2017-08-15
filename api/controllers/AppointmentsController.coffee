# AppointmentsController
#
# @description :: Server-side logic for managing appointments
# @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers


moment = require 'moment'
moment.tz = require 'moment-timezone'
getDays = require '../services/availDaysService'
#getTypes = require '../services/apptTypesService'
#getTimes = require '../services/availTimesService'
bookApptService = require '../services/bookApptService'
helpers = require '../services/helperService'
sherlock = require 'sherlockjs'
#today = moment()
fmt = require '../services/formatApptMessageService'
changeAppt = require '../services/changeAppointmentService'

auth =
    userId: 13277271
    apiKey: '268ba575326cc2fe94d6b780009bee25'


Array::where = (query) ->
  return [] if typeof query isnt "object"
  hit = Object.keys(query).length
  @filter (item) ->
    match = 0
    for key, value of query
      match += 1 if item[key] is value
    if match is hit then true else false



module.exports =

  types: (req, res) ->

    fmt.typesResponse(auth).then (responseJSON) -> res.json body:responseJSON


  days: (req, res) ->
    #console.log req
    #fixedDate = sherlock.parse req.query.date
    options =
      apptTypeName: req.query.apptTypeName
      date: moment(req.query.date).format("YYYY-MM")
      apptTypeId: req.query.apptTypeId
      tz: req.query.tz or 'America/New_York'
      calId: req.query.calId or 1024257
      day: req.query.date
    console.log options.date

    #console.log options


    fmt.getApptTypeId(auth,options).then (options) ->  getDays.getAvailDays(auth, options).then (dates) -> res.json body:dates


  times: (req, res) ->
    console.log 'test'
    fixedDate = sherlock.parse req.query.date
    console.log fixedDate.startDate
    theOptions =
      appointmentTypeID: req.query.appointmentTypeID
      date: helpers.adjustOffset(fixedDate.startDate, req.query.tz)
      calendarID: req.query.calendarID
      tz: req.query.tz
      timePref: req.query.timePref
    console.log theOptions

    fmt.timesResponse(auth, theOptions).then (responseJSON) -> res.json body:responseJSON


  bookAppt: (req, res) ->
    fixedDate = sherlock.parse "#{req.query.day} #{req.query.time}"
    #console.log "#{req.query.day} #{req.query.time}"
    #console.log moment(fixedDate.startDate).format()
    console.log req.query.phone
    options =
      firstName: req.query.firstName
      lastName: req.query.lastName
      email: req.query.email
      phone: req.query.phone
      timezone: if req.query.tz? then req.query.tz else 'America/New_York'
      date: moment(fixedDate.startDate).format() #helpers.adjustOffset(fixedDate.startDate, req.query.tz)
      appointmentTypeID: req.query.appointmentTypeID




    bookApptService.createAppt(auth, options).then (theAppt) -> fmt.formatApptResponse(theAppt).then (responseJSON) ->
      console.log responseJSON
      res.json body:responseJSON


  getAppointments: (req, res) ->
    res.send 'ok'


  cancelAppointment: (req, res) ->
    apptId = req.query.apptId
    console.log apptId
    changeAppt.cancel(apptId, auth)
      .then (canceledAppt) ->
        console.log canceledAppt
        res.send
          apptStatus:canceledAppt.apptStatus
          appt:canceledAppt.error
          message:canceledAppt.message


  findAppointment: (req, res) ->
    options =
      id:req.query.appointmentId
      email: req.query.email
      type:req.query.type

    console.log options

    changeAppt.find(options, auth).then (appts) -> res.send appts


  changeAppointment: (req, res) ->
    fixedDate = sherlock.parse "#{req.query.day} #{req.query.time}"
    options =
      id: req.query.apptId
      dt: moment(fixedDate.startDate).format()
      calId: req.query.calId

    changeAppt.change(options, auth)
      .then (appt) -> fmt.formatApptResponse(appt)
      .then (response) -> res.json body:response


  makeName: (req, res) ->

    console.log req
    firstName = "#{req.query.fname}"
    lastName =  "#{req.query.lname}"
    console.log firstName, lastName

    fullName = "#{firstName} #{lastName}"

    res.send
      firstName: firstName
      lastName: lastName
      fullName: fullName



  checkEmail: (req, res) ->
    console.log req.query.email
    res.send
      email:req.query.email


  test: (req, res) ->
    console.log req.in
    foo = JSON.parse req.in
    console.log foo
    res.send 'ok'

