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

module.exports = (tree) => {
  return new Promise((resolve) => {
    tree.match({ tag: 'i' }, (node) => {
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
    resolve(tree);
  });
};
