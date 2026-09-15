#!/usr/bin/env node
function jsonToCsv(arr) {
  if (!arr.length) return '';
  const keys = [...new Set(arr.flatMap(obj => Object.keys(obj)))];
  const header = keys.join(',');
  const rows = arr.map(obj => keys.map(k => obj[k] ?? 'null').join(','));
  return [header, ...rows].join('\n');
}

const input = process.argv[2];
if (!input) {
  console.error('Usage: json2csv \'[{"a":1,"b":1}, {"b":2,"c":3}]\'');
  process.exit(1);
}
const normalized = input
  .replace(/([a-zA-Z_]\w*)\s*:/g, '"$1":')
  .replace(/'/g, '"');
const data = JSON.parse(normalized);
const csv = jsonToCsv(data);
console.log(csv);
require('child_process').execSync(`printf '%s' "${csv.replace(/"/g, '\\"')}" | pbcopy`);
