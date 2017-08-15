 # SetController
 #
 # @description :: Server-side logic for managing sets
 # @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers

module.exports =



  # `SetController.name()`

  name: (req, res) ->
    res.json


    firstName: req.query.fname
    lastName: req.query.lname


  # `SetController.email()`

  email: (req, res) ->
    res.json
      todo: 'email() is not implemented yet!',


  # `SetController.other()`

  other: (req, res) ->
    res.json
      todo: 'other() is not implemented yet!'

