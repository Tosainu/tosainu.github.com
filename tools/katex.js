#!/usr/bin/env node

const katex = require('katex');

function readStdin() {
  return new Promise((resolve, reject) => {
    let input = '';
    process.stdin.on('data', (chunk) => {
      input += chunk;
    });
    process.stdin.on('end', () => {
      resolve(input);
    });
  });
}

readStdin()
    .then((input) => {
      let displayMode = process.argv.includes('displayMode');
      let result = katex.renderToString(input, {displayMode: displayMode});
      process.stdout.write(result);
    })
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });
