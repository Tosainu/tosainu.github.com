const gulp = require('gulp');
const cheerio = require('gulp-cheerio');
const cleancss = require('gulp-clean-css');
const concat = require('gulp-concat');
const embedsvg = require('gulp-embed-svg');
const htmlmin = require('gulp-htmlmin');
const rename = require('gulp-rename');
const sass = require('gulp-sass');
const svgmin = require('gulp-svgmin');
const del = require('del');

const browsersync = require('browser-sync').create();

const fontawesome = require('@fortawesome/fontawesome-svg-core');
fontawesome.library.add(require('@fortawesome/free-brands-svg-icons').fab);
fontawesome.library.add(require('@fortawesome/free-solid-svg-icons').fas);

function clean() {
  return del(['build/**', '!build', '!build/.git', 'tmp']);
}

function html() {
  return gulp
    .src('src/index.html')
    .pipe(
      cheerio(function ($, file) {
        $('i.fab, i.fas').each(function () {
          let i = $(this);
          let classes = i.attr('class').split(' ');
          let prefix = classes.shift();
          let name = classes.shift().replace(/^fa-/, '');
          i.replaceWith(
            fontawesome.icon(
              { prefix: prefix, iconName: name },
              { classes: classes }
            ).html
          );
        });
      })
    )
    .pipe(embedsvg({ selectors: '.avatar', root: 'tmp' }))
    .pipe(htmlmin({ collapseWhitespace: true }))
    .pipe(gulp.dest('build/'));
}

function scss() {
  return gulp
    .src('src/stylesheets/*.scss')
    .pipe(sass({ outputStyle: 'compressed' }))
    .pipe(gulp.dest('tmp/stylesheets/'));
}

function css() {
  return gulp
    .src([
      'node_modules/normalize.css/normalize.css',
      'tmp/stylesheets/*.css',
      'node_modules/@fortawesome/fontawesome-svg-core/styles.css',
    ])
    .pipe(concat('style.css'))
    .pipe(cleancss())
    .pipe(gulp.dest('build/'));
}

function svg() {
  return gulp
    .src('icon/cocoa.svg')
    .pipe(svgmin({ plugins: [{ convertPathData: { floatPrecision: 4 } }] }))
    .pipe(gulp.dest('tmp/images/'));
}

function image() {
  return gulp
    .src('icon/cocoa-512.jpg')
    .pipe(rename('icon.jpg'))
    .pipe(gulp.dest('build/'));
}

function favicon() {
  return gulp
    .src('icon/cocoa.ico')
    .pipe(rename('favicon.ico'))
    .pipe(gulp.dest('build/'));
}

function other_files() {
  return gulp.src('src/CNAME').pipe(gulp.dest('build/'));
}

const build = gulp.series(
  clean,
  svg,
  gulp.parallel(
    html,
    gulp.series(scss, css),
    image,
    favicon,
    other_files
  )
);

function reload(done) {
  browsersync.reload();
  done();
}

function serve(done) {
  browsersync.init({ server: { baseDir: 'build' } });
  done();
}

function watch() {
  gulp.watch('src/index.html', gulp.series(html, reload));
  gulp.watch('src/stylesheets/*.scss', gulp.series(scss, reload));
}

gulp.task('clean', clean);
gulp.task('build', build);
gulp.task('default', gulp.series(build, serve, watch));
