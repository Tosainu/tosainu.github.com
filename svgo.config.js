module.exports = {
  plugins: [
    {
      name: 'preset-default',
      params: {
        overrides: {
          convertPathData: {
            floatPrecision: 4,
          },
        },
      },
    },
  ],
};
