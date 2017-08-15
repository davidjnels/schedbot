
token = '2a95f70536d539148c74c3b12c3b1f659316d740'
rp = require 'request-promise'
module.exports =
  short: (url) ->
    options =
      uri: 'https://api-ssl.bitly.com/v3/shorten'
      qs:
        access_token: token
        longUrl: url

      json: true

    rp(options)
      .then (response) ->
        console.log response
        console.log response.data.url
        url = response.data.url
        return url
      .catch (err) ->
        console.log err
