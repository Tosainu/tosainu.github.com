const { defineConfig } = require('vite');
const posthtml = require('vite-plugin-posthtml');

module.exports = {
  clearScreen: false,
  plugins: [
    posthtml({
      plugins: [require('posthtml-embed-fontawesome')],
    }),
  ],
};
