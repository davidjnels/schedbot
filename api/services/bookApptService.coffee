helper = require './helperService'

Acuity = require 'acuityscheduling'
###BitLy = require 'bit.ly'
bl = new BitLy('o_5tcob5i86o', 'R_8e3149a50a53ae4adeaf1a0385653d34')###


module.exports =
  createAppt: (auth, options) ->
    acuity = Acuity.basic(auth)

    opts =
      method: 'POST'
      body:
        appointmentTypeID: options.appointmentTypeID
        datetime: helper.adjustOffset(options.date, options.timezone)
        firstName: options.firstName
        lastName: options.lastName
        email: options.email
        phone: options.phone

        timezone: options.timezone
    console.log opts
    return new Promise (resolve, reject) ->

      acuity.request "appointments", opts, (err, res, appt) ->
        if appt.error is 'no_available_calendar' then appt  = 'not_avail' else appt=appt


        console.log appt
        success = true
        if success
          resolve appt
        else
          reject Error, err
          console.log err














