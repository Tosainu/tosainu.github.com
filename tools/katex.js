#!/usr/bin/env node

const cheerio = require('cheerio');
const katex   = require('katex');

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
      const $ = cheerio.load(input, {decodeEntities: false});
      $('.math').each(function() {
        if ($(this).children().length == 0) {
          var equation = /^\\[\[\(]((.|\s)+)\\[\]\)]$/m.exec($(this).text())[1];
          var result   = katex.renderToString(equation, {displayMode: $(this).is('.display')});
          $(this).html(result);
        }
      });
      console.log($('body').html());
    })
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });
