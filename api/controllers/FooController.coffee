# FooController
#
# @description :: Server-side logic for managing foos
# @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
Acuity = require 'acuityscheduling'
acuity = Acuity.basic(
  userId: 13277271,
  apiKey: '3d97f0676ab38e48d902d8c7cd138855'
)
moment = require 'moment'
moment.tz = require 'moment-timezone'
module.exports = {

  getApptTypes: (req, res) ->
    acuity.request 'appointment-types', (err, response, appointmentTypes) ->
      #console.log appointmentTypes
      results = JSON.stringify appointmentTypes
      data = JSON.parse results
      types = []
      for apt in data
        types.push
          id: apt.id, name: apt.name.toLowerCase(), duration: apt.duration
      #type = req.query.type
      #      typeSelect = (type) ->
      #        if type isnt null
      res.json types

  findAppointment: (req, res) ->
    acuity.request 'appointments', (err, response, appointments) ->
#      console.log appointments
      results = JSON.stringify appointments
      data = JSON.parse results
      appts = []
      for appt in data
        appts.push
          id: appt.id,
          name: appt.type.toLowerCase(),
          duration: appt.duration,
          firstName: appt.firstName,
          lastName: appt.lastName,
          date: appt.date,
          time: appt.time,
          end: appt.endTime,
          phone: appt.phone,
          email: appt.email

      emailFilter = req.query.email


      filter = (email) -> x for x in appts when x.email is email
      getAppts = (email, myAppts)->
        myAppts = []

        if email is 'all'
          return myAppts = appts
        else
          return myAppts = filter(email)
      console.log getAppts(emailFilter)
      res.json getAppts(emailFilter)

  getDates: (req, res) ->
    month1 =  moment(req.query.month).utcOffset(-5)
    m = month1.format("YYYY-MM")
    apptId =req.query.apptId
    tz = req.query.tz
    calId = req.query.calId

    acuity.request "availability/dates?appointmentTypeID=#{apptId}&calendarID=#{calId}&month=#{m}&timezone=#{tz}", (err, response, days) ->
      results = JSON.stringify days
      console.log days
      data = JSON.parse results
      availDates = []
      for day in data
        availDates.push
          date:day.date,
          day:moment(day.date).format("dddd")
          dayFriendly:moment(day.date).calendar()

      console.log m
      console.log availDates
      res.json availDates

  getTimes: (req, res) ->
    tz = req.query.tz
    dcheck = moment(req.query.date).isDST()
    date = if dcheck is true then moment(req.query.date).utcOffset(-4).format() else moment(req.query.date).utcOffset(-5).format()
    day = moment(date).format("YYYY-MM-DD")
    apptTypeId = req.query.apptTypeId


    acuity.request "availability/times?appointmentTypeID=#{apptTypeId}&date=#{day}&timezone=#{tz}", (err, response,appointmentTimes) ->
      #console.log appointmentTimes
      results = JSON.stringify appointmentTimes
      data = JSON.parse results
      availTimes = []
      for time in data
        availTimes.push
          time:moment(time.time).format(),
          timeFriendly:moment(time.time).calendar(null,
            sameElse: 'dddd, MMMM Do, YYYY [at] Ha'),
          available: if time.slotsAvailable >0 then true,
          slots:time.slotsAvailable,
          matchRequest: if moment(date).isSame(time.time)  and time.slotsAvailable >0 then "match" else "nomatch"


      availTimes2 = if availTimes.length > 0 then availTimes else "nothing available"
      res.json availTimes2
      console.log "ok"
      for m in availTimes2
        if m.matchRequest is "match" then console.log m

  makeAppointment: (req, res) ->
    apptId = req.query.apptId
    dt = req.query.dateTime
    email = req.query.email.toLowerCase()
    fn = req.query.firstName
    ln = req.query.lastName
    tz = req.query.tz

    options =
      method: 'POST'
      body:
        appointmentTypeID: apptId,
        datetime: dt,
        firstName: fn,
        lastName: ln,
        email: email,
        phone: req.query.phone,
        timezone: tz

    acuity.request 'appointments', options, (err, response, appointment) ->
      console.log appointment
      results = JSON.stringify appointment


      res.json appointment

  cancelAppt: (req, res) ->
    id = req.query.apptId
    note = req.query.note

    options =
      method: 'PUT',
      body:
        cancelNote: note

    acuity.request "appointments/#{id}/cancel", options, (err, response, appointment) ->
      if err then console.log err
      res.json appointment


}
