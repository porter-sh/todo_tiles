#!/usr/bin/env node

var ts = require('../')

if (isNaN(process.argv[2])) return console.log(
  'Usage: ts [TIMESTAMP]'    
)

console.log(ts(process.argv[2]))
