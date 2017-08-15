/**
 * DemoController
 *
 * @description :: Server-side logic for managing demoes
 * @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
 */

module.exports = {


  /**
   * `DemoController.greet()`
   */
  nextOpening: function (req, res) {

    var name = req.query.name;
    var fdate = sails.moment(req.query.date1).calendar();

    return res.json({
      timeAvailable: 'hi ' + name + '! There is an opening ' + fdate
    });
  },

/** Get all appointments for given calendar - TODO: Add individual calendar support */


  getAppointments: function (req, res) {
    var test1 = req.query.test1;

    var acuity = sails.acuity.basic({
      userId: 13277271,
      apiKey: '3d97f0676ab38e48d902d8c7cd138855'
    });
    acuity.request('/appointments', function (err, response, appointments) {
      if (err) return console.error(err);
      console.log(arguments);
      console.log('-> response: ', response);
      console.log('-> appointment: ', appointments);
      res.json(appointments);
    });
  },

  /** get types of appointments - TODO: add options */


  getAppointmentTypes: function (req, res) {


    var acuity = sails.acuity.basic({
      userId: 13277271,
      apiKey: '3d97f0676ab38e48d902d8c7cd138855'
    });
    acuity.request('appointment-types', function (err, response, appointmentTypes) {
      if (err) return console.error(err);
      console.log(arguments);
      console.log(response);
      console.log(appointmentTypes);





      var data = appointmentTypes;
      var sessions = [];

      var apptNames = data.map(function(par){
        return par.name;
      });

      var apptLength = data.map(function(par){
        return par.duration;
      });

      res.json({
        "apptTypes":data
      });
    });
  },

  /** Get individual appointment by Id **/

  getAppointmentById: function (req, res) {
    var apptId = req.query.apptId;

    var acuity = sails.acuity.basic({
      userId: 13277271,
      apiKey: '3d97f0676ab38e48d902d8c7cd138855'
    });
    acuity.request('appointments/' + apptId, function (err, response, appointment) {
      if (err) return console.error(err);
      console.log(arguments);
      console.log('-> response: ', response);
      console.log('-> appointment: ', appointment);
      res.json(appointment
      );
    });
  },




};


/*    var acuity = sails.acuity.basic(
 {
 userId: 13277271,
 apiKey: '3d97f0676ab38e48d902d8c7cd138855'
 }*/









