// skel.js
skel.init({
  resetCSS: false,
  boxModel: "border",
  prefix: "/css/style",
  breakpoints: {
    wide: {
      range: "1280-",
      containers: 1140,
      grid: { gutters: 50 }
    },
    narrow: {
      range: "769-1279",
      containers: "fluid",
      grid: { gutters: 10 } 
    },
    mobile: {
      range: "-768",
      containers: "fluid",
      grid: { collapse: true }
    }
  }
});
