const posthtml = require('posthtml');

module.exports = (opts = {}) => {
  return {
    name: 'posthtml',
    enforce: 'post',
    async transformIndexHtml(src) {
      const { html } = await posthtml(opts.plugins || []).process(
        src,
        opts.options || {}
      );
      return html;
    },
  };
};
