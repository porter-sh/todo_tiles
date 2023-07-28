var intervals = {
  YEAR: 31557600000, 
  WEEK: 604800000,
  DAY: 86400000,
  HOUR: 3600000,
  MINUTE: 60000,
  SECOND: 1000,
  MILLISECOND: 1
}

function span(val) {
  if (typeof val == 'number' || val == parseInt(val, 10)) return str(val);
  return ms(val);
};

function ms(str) {
  var date = parseDate(str);
  var ms = 0;
  for (var type in date) {
    if (type == 'ms') ms += date[type];
    if (type == 's') ms += date[type] * intervals.SECOND;
    if (type == 'm') ms += date[type] * intervals.MINUTE;
    if (type == 'h') ms += date[type] * intervals.HOUR;
    if (type == 'd') ms += date[type] * intervals.DAY;
    if (type == 'w') ms += date[type] * intervals.WEEK;
    if (type == 'y') ms += date[type] * intervals.YEAR;
  }
  return ms;
}

function str(ms) {
  var output = [];
  var buf;
  for (var i in intervals) {
    if (ms>=intervals[i]) {
      buf = Math.floor(ms/intervals[i]);
      if (i!='MILLISECOND') {
        output.push(buf+i.substr(0,1).toLowerCase());
      } else if (!output.length) {
        output.push(buf+'ms');
      }
      ms -= buf*intervals[i];
    }
  }
  return output.join(' ');
}

function parseDate(str) {
  var str = str.replace(/ /g, '');
  
  if (str.search('in') > -1) return parseRelative(str);
  if (str.search(':') > -1) throw 'Absolute date parsing not yet implemented';
  return parseRelative(str);
}

function parseRelative(str) {
  var str = str
    .replace(/in/, '')
    .replace(/years|year|jahr|jahre|y|j/, 'y')
    .replace(/weeks|week|wochen|woche/, 'w')
    .replace(/days|day|tage|tag/, 'd')
    .replace(/hours|hour|stunden|stunde/, 'h')
    .replace(/minutes|minute|mins|min|minuten/, 'm')
    .replace(/seconds|second|secs|sec|sekunden|sekunde|sek/, 's')

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

module.exports = span;
