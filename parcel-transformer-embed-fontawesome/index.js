const { Transformer } = require('@parcel/plugin');
const { render } = require('posthtml-render');
const semver = require('semver');
const nullthrows = require('nullthrows');
const PostHTML = require('posthtml');

const fontawesome = require('@fortawesome/fontawesome-svg-core');
fontawesome.library.add(require('@fortawesome/free-brands-svg-icons').fab);
fontawesome.library.add(require('@fortawesome/free-solid-svg-icons').fas);

const toPostHTMLNode = ({ tag, attributes, children }) => {
  return {
    tag: tag,
    attrs: attributes,
    content: children?.map(toPostHTMLNode) || [],
  };
};

module.exports = new Transformer({
  canReuseAST({ ast }) {
    return ast.type === 'posthtml' && semver.satisfies(ast.version, '^0.4.0');
  },

  async parse({ asset }) {
    return {
      type: 'posthtml',
      version: '0.4.1',
      program: parser(await asset.getCode(), {
        lowerCaseAttributeNames: true,
      }),
    };
  },

  async transform({ asset }) {
    const ast = nullthrows(await asset.getAST());

    PostHTML().walk.call(ast.program, (node) => {
      if (node.tag != 'i') {
        return node;
      }

      let classes = (node.attrs && node.attrs.class.split(' ')) || [];
      if (!(classes.includes('fab') || classes.includes('fas'))) {
        return node;
      }

      let prefix = classes.shift();
      let name = classes.shift().replace(/^fa-/, '');
      return fontawesome
        .icon({ prefix: prefix, iconName: name }, { classes: classes })
        .abstract.map(toPostHTMLNode);
    });

    asset.setAST(ast);
    return [asset];
  },

  generate({ ast }) {
    return {
      content: render(ast.program),
    };
  },
});
