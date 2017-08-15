// Generated by CoffeeScript 1.12.4
(function() {
  var shortAnswer;

  shortAnswer = require('../services/wolfram/mathService');

  module.exports = {
    math: function(req, res) {
      return shortAnswer(req.query.q).then(function(resp) {
        return res.send({
          question: req.query.q,
          answer: resp
        });
      });
    },
    question: function(req, res) {
      return res.json({
        todo: 'question() is not implemented yet!'
      });
    }
  };

}).call(this);

//# sourceMappingURL=Short-answerController.js.map