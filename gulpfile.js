const gulp     = require('gulp');
const cheerio  = require('gulp-cheerio');
const cleancss = require('gulp-clean-css');
const embedsvg = require('gulp-embed-svg');
const htmlmin  = require('gulp-htmlmin');
const rename   = require('gulp-rename');
const sass     = require('gulp-sass');

const fontawesome = require('@fortawesome/fontawesome-svg-core');
fontawesome.library.add(require('@fortawesome/free-brands-svg-icons').fab);
fontawesome.library.add(require('@fortawesome/free-solid-svg-icons').fas);

function html() {
  return gulp.src('src/index.html')
      .pipe(embedsvg({root: 'src'}))
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

function other_files() {
  return gulp.src('src/{CNAME,favicon.ico}')
      .pipe(gulp.dest('build/'));
}

const build = gulp.parallel(html, scss, css, other_files);

gulp.task('build', build);
gulp.task('default', build);
