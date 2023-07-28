var span = require('span')

module.exports = timestamp

function timestamp (ts) {
  ts *= 1000
  var dt = Date.now() - ts
  return [
    new Date(ts).toString(),
    ' (',
    span(Math.abs(dt)),
    ' ',
    dt > 0? 'ago' : 'ahead',
    ')'
  ].join('')
} 
