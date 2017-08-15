moment = require 'moment'
Acuity = require 'acuityscheduling'
#auth = sails.globals.acuity

module.exports =
  get: (auth) ->
    acuity = Acuity.basic(auth)
    return new Promise (resolve, reject) ->
      acuity.request 'appointment-types', (err, response, appointmentTypes) ->
        data = []
        for d in appointmentTypes
          data.push
            name: d.name
            id: d.id
            desc: if d.description is '' then 'none' else d.description
            category: if d.category is '' then 'none' else d.category
            type: d.type
            price: if d.price is '' then 'free' else d.price
            duration: d.duration
            calId: d.calendarIDs

        #console.log data
        success = true
        if success
          resolve data
        else
          reject Error 'fuck'


###auth =
  userId: 13277271,
  apiKey: '3d97f0676ab38e48d902d8c7cd138855'
console.log getTypes(auth).then (data) -> console.log data###
