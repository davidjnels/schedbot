 # Check-authController
 #
 # @description :: Server-side logic for managing check-auths
 # @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
Acuity = require 'acuityscheduling'


testCred = (userId, apiKey) ->
  auth =
    userId:userId
    apiKey:apiKey
  console.log auth
  acuity = Acuity.basic(auth)
  return new Promise (resolve, reject) ->


    acuity.request 'appointments?max=1', (err, response, appts) ->
      console.log appts

      status = switch
        when appts.error? then 'failed'
        when appts[0]? then status = 'ok'
        else 'failed'
      success = true
      if success
        resolve status
      else reject Error, err

module.exports =



  # `Check-authController.test()`

test: (req, res) ->
    userId = req.query.userId
    apiKey = req.query.apiKey

    testCred(userId, apiKey).then (results) -> res.send status:results



###userId = 13277271
apiKey = '268ba575326cc2fe94d6b780009bee25'

testCred(userId,apiKey)###
