 # Short-answerController
 #
 # @description :: Server-side logic for managing short-answers
 # @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
shortAnswer = require '../services/wolfram/mathService'
module.exports =



  # `Short-answerController.math()`

  math: (req, res) ->

    shortAnswer(req.query.q).then (resp) ->
      res.send
        question: req.query.q
        answer:resp

  # `Short-answerController.question()`

  question: (req, res) ->
    res.json
      todo: 'question() is not implemented yet!'

