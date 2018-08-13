const gulp     = require('gulp');
const cheerio  = require('gulp-cheerio');
const cleancss = require('gulp-clean-css');
const embedsvg = require('gulp-embed-svg');
const htmlmin  = require('gulp-htmlmin');
const rename   = require('gulp-rename');
const sass     = require('gulp-sass');
const svgmin   = require('gulp-svgmin');
const del      = require('del');

const browsersync = require('browser-sync').create();

const fontawesome = require('@fortawesome/fontawesome-svg-core');
fontawesome.library.add(require('@fortawesome/free-brands-svg-icons').fab);
fontawesome.library.add(require('@fortawesome/free-solid-svg-icons').fas);

function clean() {
  return del(['build/**', '!build', '!build/.git', 'tmp']);
}

function html() {
  return gulp.src('src/index.html')
      .pipe(cheerio(function($, file) {
        $('i.fab, i.fas').each(function() {
          let i       = $(this);
          let classes = i.attr('class').split(' ');
          let prefix  = classes.shift();
          let name    = classes.shift().replace(/^fa-/, '');
          i.replaceWith(
              fontawesome.icon({prefix: prefix, iconName: name}, {classes: classes}).html);
        });
      }))
      .pipe(embedsvg({selectors: '.avatar', root: 'tmp'}))
      .pipe(htmlmin({collapseWhitespace: true}))
      .pipe(gulp.dest('build/'));
}

function scss() {
  return gulp.src('src/stylesheets/*.scss')
      .pipe(sass({outputStyle: 'compressed'}))
      .pipe(gulp.dest('build/stylesheets/'));
}

function css() {
  return gulp.src('node_modules/@fortawesome/fontawesome-svg-core/styles.css')
      .pipe(rename('fontawesome.css'))
      .pipe(gulp.src('node_modules/normalize.css/normalize.css'))
      .pipe(cleancss())
      .pipe(gulp.dest('build/stylesheets/'));
}

function svg() {
  return gulp.src(['src/images/*.svg', 'icon/cocoa.svg'])
      .pipe(svgmin({plugins: [{convertPathData: {floatPrecision: 4}}]}))
      .pipe(gulp.dest('tmp/images/'));
}

function other_files() {
  return gulp.src('src/{CNAME,favicon.ico}')
      .pipe(gulp.dest('build/'));
}

const build = gulp.series(clean, svg, gulp.parallel(html, scss, css, other_files));

function reload(done) {
  browsersync.reload();
  done();
}

function serve(done) {
  browsersync.init({server: {baseDir: 'build'}});
  done();
}

function watch() {
  gulp.watch('src/index.html', gulp.series(html, reload));
  gulp.watch('src/stylesheets/*.scss', gulp.series(scss, reload));
}

gulp.task('clean', clean);
gulp.task('build', build);
gulp.task('default', gulp.series(build, serve, watch));
