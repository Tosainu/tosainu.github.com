const gulp = require('gulp');
const htmlmin = require('gulp-htmlmin');

function html() {
  return gulp.src('src/index.html')
      .pipe(htmlmin({collapseWhitespace: true}))
      .pipe(gulp.dest('build/'));
}

function other_files() {
  return gulp.src('src/{CNAME,favicon.ico}')
      .pipe(gulp.dest('build/'));
}

const build = gulp.parallel(html, other_files);

gulp.task('build', build);
gulp.task('default', build);
