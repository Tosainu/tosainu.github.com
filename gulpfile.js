const gulp = require('gulp');
const embedsvg = require('gulp-embed-svg');
const htmlmin = require('gulp-htmlmin');
const sass = require('gulp-sass');

function html() {
  return gulp.src('src/index.html')
      .pipe(embedsvg({
        root: 'src'
      }))
      .pipe(htmlmin({collapseWhitespace: true}))
      .pipe(gulp.dest('build/'));
}

function scss() {
  return gulp.src('src/stylesheets/*.scss')
      .pipe(sass({
        outputStyle: 'compressed'
      }))
      .pipe(gulp.dest('build/stylesheets/'));
}

function css() {
  return gulp.src('node_modules/normalize.css/normalize.css')
      .pipe(gulp.dest('build/stylesheets/'));
}

function other_files() {
  return gulp.src('src/{CNAME,favicon.ico}')
      .pipe(gulp.dest('build/'));
}

const build = gulp.parallel(html, scss, css, other_files);

gulp.task('build', build);
gulp.task('default', build);
