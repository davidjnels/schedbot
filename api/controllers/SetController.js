// Generated by CoffeeScript 1.12.4
(function() {
  module.exports = {
    name: function(req, res) {
      res.json;
      return {
        firstName: req.query.fname,
        lastName: req.query.lname
      };
    },
    email: function(req, res) {
      return res.json({
        todo: 'email() is not implemented yet!'
      });
    },
    other: function(req, res) {
      return res.json({
        todo: 'other() is not implemented yet!'
      });
    }
  };

}).call(this);

//# sourceMappingURL=SetController.js.map