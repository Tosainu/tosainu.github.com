#!/usr/bin/env node

const {library, icon} = require('@fortawesome/fontawesome-svg-core');
library.add(require('@fortawesome/free-brands-svg-icons').fab);
library.add(require('@fortawesome/free-solid-svg-icons').fas);

let o = {};
for (prefix in library.definitions) {
  o[prefix] = {};
  for (name in library.definitions[prefix]) {
    o[prefix][name] = icon({prefix: prefix, iconName: name}).abstract[0];
  }
}
process.stdout.write(JSON.stringify(o));
