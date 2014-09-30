// skel.js
skel.init({
  resetCSS: true,
  boxModel: "border",
  prefix: "/css/style",
  breakpoints: {
    wide: {
      range: "1280-",
      containers: 1140,
    },
    narrow: {
      range: "-1279",
      containers: "fluid",
    },
    mobile: {
      range: "-768",
      containers: "fluid",
      grid: { collapse: true }
    }
  }
});
