 # FbNameController
 #
 # @description :: Server-side logic for managing fbnames
 # @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers

module.exports =



  # `FbNameController.set()`

  set: (req, res) ->
    res.send
      fname: req.query.fname
      lname: req.query.lname

