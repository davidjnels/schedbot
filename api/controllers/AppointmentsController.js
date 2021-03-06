// Generated by CoffeeScript 1.12.5
(function() {
  var auth, bookApptService, changeAppt, fmt, getDays, helpers, moment, sherlock;

  moment = require('moment');

  moment.tz = require('moment-timezone');

  getDays = require('../services/availDaysService');

  bookApptService = require('../services/bookApptService');

  helpers = require('../services/helperService');

  sherlock = require('sherlockjs');

  fmt = require('../services/formatApptMessageService');

  changeAppt = require('../services/changeAppointmentService');

  auth = {
    userId: 13277271,
    apiKey: '268ba575326cc2fe94d6b780009bee25'
  };

  Array.prototype.where = function(query) {
    var hit;
    if (typeof query !== "object") {
      return [];
    }
    hit = Object.keys(query).length;
    return this.filter(function(item) {
      var key, match, value;
      match = 0;
      for (key in query) {
        value = query[key];
        if (item[key] === value) {
          match += 1;
        }
      }
      if (match === hit) {
        return true;
      } else {
        return false;
      }
    });
  };

  module.exports = {
    types: function(req, res) {
      return fmt.typesResponse(auth).then(function(responseJSON) {
        return res.json({
          body: responseJSON
        });
      });
    },
    days: function(req, res) {
      var options;
      options = {
        apptTypeName: req.query.apptTypeName,
        date: moment(req.query.date).format("YYYY-MM"),
        apptTypeId: req.query.apptTypeId,
        tz: req.query.tz || 'America/New_York',
        calId: req.query.calId || 1024257,
        day: req.query.date
      };
      console.log(options.date);
      return fmt.getApptTypeId(auth, options).then(function(options) {
        return getDays.getAvailDays(auth, options).then(function(dates) {
          return res.json({
            body: dates
          });
        });
      });
    },
    times: function(req, res) {
      var fixedDate, theOptions;
      console.log('test');
      fixedDate = sherlock.parse(req.query.date);
      console.log(fixedDate.startDate);
      theOptions = {
        appointmentTypeID: req.query.appointmentTypeID,
        date: helpers.adjustOffset(fixedDate.startDate, req.query.tz),
        calendarID: req.query.calendarID,
        tz: req.query.tz,
        timePref: req.query.timePref
      };
      console.log(theOptions);
      return fmt.timesResponse(auth, theOptions).then(function(responseJSON) {
        return res.json({
          body: responseJSON
        });
      });
    },
    bookAppt: function(req, res) {
      var fixedDate, options;
      fixedDate = sherlock.parse(req.query.day + " " + req.query.time);
      console.log(req.query.phone);
      options = {
        firstName: req.query.firstName,
        lastName: req.query.lastName,
        email: req.query.email,
        phone: req.query.phone,
        timezone: req.query.tz != null ? req.query.tz : 'America/New_York',
        date: moment(fixedDate.startDate).format(),
        appointmentTypeID: req.query.appointmentTypeID
      };
      return bookApptService.createAppt(auth, options).then(function(theAppt) {
        return fmt.formatApptResponse(theAppt).then(function(responseJSON) {
          console.log(responseJSON);
          return res.json({
            body: responseJSON
          });
        });
      });
    },
    getAppointments: function(req, res) {
      return res.send('ok');
    },
    cancelAppointment: function(req, res) {
      var apptId;
      apptId = req.query.apptId;
      console.log(apptId);
      return changeAppt.cancel(apptId, auth).then(function(canceledAppt) {
        console.log(canceledAppt);
        return res.send({
          apptStatus: canceledAppt.apptStatus,
          appt: canceledAppt.error,
          message: canceledAppt.message
        });
      });
    },
    findAppointment: function(req, res) {
      var options;
      options = {
        id: req.query.appointmentId,
        email: req.query.email,
        type: req.query.type
      };
      console.log(options);
      return changeAppt.find(options, auth).then(function(appts) {
        return res.send(appts);
      });
    },
    changeAppointment: function(req, res) {
      var fixedDate, options;
      fixedDate = sherlock.parse(req.query.day + " " + req.query.time);
      options = {
        id: req.query.apptId,
        dt: moment(fixedDate.startDate).format(),
        calId: req.query.calId
      };
      return changeAppt.change(options, auth).then(function(appt) {
        return fmt.formatApptResponse(appt);
      }).then(function(response) {
        return res.json({
          body: response
        });
      });
    },
    makeName: function(req, res) {
      var firstName, fullName, lastName;
      console.log(req);
      firstName = "" + req.query.fname;
      lastName = "" + req.query.lname;
      console.log(firstName, lastName);
      fullName = firstName + " " + lastName;
      return res.send({
        firstName: firstName,
        lastName: lastName,
        fullName: fullName
      });
    },
    checkEmail: function(req, res) {
      console.log(req.query.email);
      return res.send({
        email: req.query.email
      });
    },
    test: function(req, res) {
      var foo;
      console.log(req["in"]);
      foo = JSON.parse(req["in"]);
      console.log(foo);
      return res.send('ok');
    }
  };

}).call(this);

//# sourceMappingURL=AppointmentsController.js.map
