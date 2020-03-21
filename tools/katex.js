#!/usr/bin/env node

const fs = require('fs');
const katex = require('katex');

const input = fs.readFileSync(process.stdin.fd, 'utf-8');
const displayMode = process.argv.includes('displayMode');
const result = katex.renderToString(input, { displayMode: displayMode });
process.stdout.write(result);
