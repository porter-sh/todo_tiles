var intervals = {
  YEAR: 31557600000, 
  WEEK: 604800000,
  DAY: 86400000,
  HOUR: 3600000,
  MINUTE: 60000,
  SECOND: 1000,
  MILLISECOND: 1
};

module.exports = span;

/**
 * Convert a number to span string and vice versa.
 *
 * @param {Number|String} val
 * @return {Number|String}
 * @api public
 */

function span(val) {
  return typeof val == 'number' || val == parseInt(val, 10)
    ? str(val)
    : ms(val);
};

/**
 * Convert `ms` to a span string.
 *
 * @param {Number} ms
 * @return {String}
 * @api private
 */

function str(ms) {
  var output = [];
  var buf;
  for (var i in intervals) {
    if (ms >= intervals[i]) {
      buf = Math.floor(ms/intervals[i]);
      if (i != 'MILLISECOND') {
        output.push(buf + i.substr(0,1).toLowerCase());
      } else if (!output.length) {
        output.push(buf + 'ms');
      }
      ms -= buf * intervals[i];
    }
  }
  return output.join(' ');
}

/**
 * Convert a date `str` to milliseconds.
 *
 * @param {String} str
 * @return {Number}
 * @api private
 */

function ms(str) {
  var date = parseDate(str);
  var ms = 0;
  for (var type in date) {
    switch(type) {
      case 'ms': ms += date[type]; break;
      case 's': ms += date[type] * intervals.SECOND; break;
      case 'm': ms += date[type] * intervals.MINUTE; break;
      case 'h': ms += date[type] * intervals.HOUR; break;
      case 'd': ms += date[type] * intervals.DAY; break;
      case 'w': ms += date[type] * intervals.WEEK; break;
      case 'y': ms += date[type] * intervals.YEAR;
    }
  }
  return ms;
}

/**
 * Parse an absolute or relative date string into a span in milliseconds.
 *
 * @param {String} str
 * @return {Number}
 * @api private
 */

function parseDate(str) {
  var str = str.replace(/ /g, '');
  
  if (str.indexOf('in') > -1) return parseRelative(str);
  if (str.indexOf(':') > -1) throw 'Absolute date parsing not yet implemented';
  return parseRelative(str);
}

/**
 * Parse a relative span `str`.
 *
 * @param {String} str
 * @return {Object}
 * @api private
 * @todo write proper parser and move to seperate project
 */

function parseRelative(str) {
  var str = str
    .replace(/in/, '')
    .replace(/years?|jahre?|j/, 'y')
    .replace(/weeks?|wochen?/, 'w')
    .replace(/days?|tage?/, 'd')
    .replace(/hours?|stunden?/, 'h')
    .replace(/minutes?|mins?|minuten?/, 'm')
    .replace(/seconds?|secs?|sekunden?|sek/, 's');

  var duration = 0;
  var date = {};
  var numBuffer = [];
  for (var i = 0; i < str.length; i++) {
    if (str.charCodeAt(i) < 97) {
      numBuffer.push(str[i]);
    } else {
      date[str[i]] = parseInt(numBuffer.join(''), 10);
      numBuffer = [];
    };
  }
  return date;
}
