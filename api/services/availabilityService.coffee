

moment = require 'moment'
Acuity = require 'acuityscheduling'
acuity = Acuity.basic(
  userId: 13277271,
  apiKey: '3d97f0676ab38e48d902d8c7cd138855'
)

dates = dates ? this

getDates = (cb) ->
  cb = cb || ->
  acuity.request 'availability', (err, response, availability) ->
    results = JSON.stringify availability
    parsedResults = JSON.parse results
    
