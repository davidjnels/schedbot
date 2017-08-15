rp = require 'request-promise'



appId = 'PEH42J-2UXG6GHW2L'

replaceP = (utt) -> utt.replace /%/, ' percent'
mathQuery = (utt) ->
  foo = replaceP(utt)

###
options =
  url: "http://api.wolframalpha.com/v1/result"
  qs:
    access_token: appId
    i:mathQuery
###



factService = (utt) ->
  options =
    #resolveWithFullResponse: true,
    url: "http://api.wolframalpha.com/v1/result?appid=#{appId}&i=#{mathQuery(utt)}"
  rp(options)
    .then (resp) ->
      resp
    .catch (err) -> "Sorry, that didn't make sense!"

    ###  success = true
      if success
        resolve resp
      else
        reject Error, err###

module.exports = factService
###
module.exports =
  short: (utter) ->
    utt = utter
    mathService(utt)
      .then (resp) ->
        console.log resp
        Promise.resolve(resp)


###

