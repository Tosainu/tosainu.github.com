const gulp = require('gulp');

function other_files() {
  return gulp.src('src/{CNAME,favicon.ico}')
      .pipe(gulp.dest('build/'));
}

const build = gulp.parallel(other_files);

gulp.task('build', build);
gulp.task('default', build);
