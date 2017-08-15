// Generated by CoffeeScript 1.12.5
(function() {
  var _, apptTypes, getDays, getTimes, rp, shortLink;

  rp = require('request-promise');

  shortLink = require('./shortLink');

  apptTypes = require('./apptTypesService');

  _ = require('underscore');

  getDays = require('./availDaysService');

  getTimes = require('./availTimesService');

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

  if (!Array.prototype.filter) {
    Array.prototype.filter = function(callback) {
      var element, i, len, ref, results;
      ref = this;
      results = [];
      for (i = 0, len = ref.length; i < len; i++) {
        element = ref[i];
        if (callback(element)) {
          results.push(element);
        }
      }
      return results;
    };
  }

  module.exports = {
    formatApptResponse: function(appt) {
      return new Promise(function(resolve, reject) {
        return shortLink.short(appt.confirmationPage).then(function(data) {
          var confirmationPage, date, firstName, id, responseJSON, responseString, start, success, type;
          id = appt.id;
          firstName = appt.firstName;
          start = appt.time;
          date = appt.date;
          confirmationPage = data;
          type = appt.type;
          responseJSON = {
            response: "",
            "continue": true,
            customPayload: "",
            quickReplies: ["okay"],
            cards: null
          };
          responseString = "Ok " + firstName + ", your're all set! Here's your appointment ID " + id + "::next-2000::You're booked for a " + type + " on " + date + " at " + start + ".::next-2000::Here's a link to you confirmation page - " + confirmationPage + ".::next-1800::Just so you know, you can always change your appointment, either on your confirmation page, or by sending me a message that says \"change my appointment\"!";
          if (appt === 'not_avail') {
            responseJSON.response = "Sorry about this, but there isn't a slot available then. Do you want to try a different time?";
          } else {
            responseJSON.response = responseString;
          }
          if (responseJSON.response !== responseString) {
            responseJSON.quickReplies = ["yes", "no"];
          }
          console.log(responseJSON);
          responseJSON.customVars = {
            appointmentId: id,
            apptDay: appt.date,
            apptType: appt.type,
            apptTime: appt.time,
            apptDateTime: appt.datetime,
            apptStatus: "booked"
          };
          success = true;
          if (success) {
            return resolve(responseJSON);
          } else {
            return reject(Error, err);
          }
        });
      });
    },
    webhookApptResponse: function(appt) {
      return new Promise(function(resolve, reject) {
        return shortLink.short(appt.confirmationPage).then(function(data) {
          var confirmationPage, date, firstName, id, responseJSON, responseString, start, success, type;
          id = appt.id;
          firstName = appt.firstName;
          start = appt.time;
          date = appt.date;
          confirmationPage = data;
          type = appt.type;
          responseJSON = {
            response: "",
            "continue": true,
            customPayload: "",
            quickReplies: ["okay"],
            cards: null
          };
          responseString = "Ok " + firstName + ", your're all set! Here's your appointment ID " + id + "::next-2000::You're booked for a " + type + " on " + date + " at " + start + ".::next-2000::Here's a link to you confirmation page - " + confirmationPage + ".::next-1800::Just so you know, you can always change your appointment, either on your confirmation page, or by sending me a message that says \"change my appointment\"!";
          if (appt === 'not_avail') {
            responseJSON.response = "Sorry about this, but there isn't a slot available then. Do you want to try a different time?";
          } else {
            responseJSON.response = responseString;
          }
          if (responseJSON.response !== responseString) {
            responseJSON.quickReplies = ["yes", "no"];
          }
          console.log(responseJSON);
          success = true;
          if (success) {
            return resolve(responseJSON);
          } else {
            return reject(Error, err);
          }
        });
      });
    },
    typesResponse: function(auth) {
      return new Promise(function(resolve, reject) {
        return apptTypes.get(auth).then(function(data) {
          var d, responseJSON, success;
          console.log(data);
          responseJSON = {
            response: "What kind of appointment do you want to book?",
            "continue": false,
            customPayload: "",
            quickReplies: (function() {
              var i, len, results;
              results = [];
              for (i = 0, len = data.length; i < len; i++) {
                d = data[i];
                results.push(d.name);
              }
              return results;
            })(),
            cards: null
          };

          /*for d in data
            responseJSON.push customPayload: d.id
           */
          console.log(responseJSON);
          success = true;
          if (success) {
            return resolve(responseJSON);
          } else {
            return reject(Error, err);
          }
        });
      });
    },
    getApptTypeId: function(auth, options) {
      return new Promise(function(resolve, reject) {
        return apptTypes.get(auth).then(function(data) {
          var apptId, dat, dn, i, len, success;
          apptId = '';
          for (i = 0, len = data.length; i < len; i++) {
            dat = data[i];
            dn = dat.name;
            console.log(dat.name);
            if (options.apptTypeName === dn) {
              apptId = dat.id;
            }
          }
          options.apptTypeId = apptId;
          console.log(options);
          success = true;
          if (success) {
            return resolve(options);
          } else {
            return reject(Error, err);
          }
        });
      });
    },
    timesResponse: function(auth, options) {
      return new Promise(function(resolve, reject) {
        console.log(options);
        return getTimes.getAvailTimes(auth, options).then(function(goodTimes) {
          var goodtimes, pref, response, responseJSON, success, time, timeArr;
          console.log(goodTimes);
          pref = goodTimes.timePref;
          timeArr = goodTimes.times;
          goodtimes = (function() {
            var i, len, results;
            results = [];
            for (i = 0, len = timeArr.length; i < len; i++) {
              time = timeArr[i];
              if (time.timeOfDay === pref) {
                results.push(time);
              }
            }
            return results;
          })();
          response = goodtimes.length > 0 ? "here's what we've got available. Any of these work for you?" : "hmmm... I didn't find anything available. Do you want to check a different day?";
          console.log(goodtimes);
          responseJSON = {
            response: response,
            "continue": true,
            customPayload: "",
            quickReplies: (function() {
              var i, len, results;
              results = [];
              for (i = 0, len = goodtimes.length; i < len; i++) {
                time = goodtimes[i];
                results.push(time.timeFriendly);
              }
              return results;
            })(),
            cards: null
          };
          responseJSON.customVars = {
            day: goodTimes.day
          };
          success = true;
          if (success) {
            return resolve(responseJSON);
          } else {
            return reject(Error, err);
          }
        });
      });
    }
  };

}).call(this);

//# sourceMappingURL=formatApptMessageService.js.map
