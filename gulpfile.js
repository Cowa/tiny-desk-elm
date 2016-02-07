var gulp = require('gulp');
var elm = require('gulp-elm');
var rename = require('gulp-rename');
var concat = require('gulp-concat');

var paths = {
  html: 'src/index.html',
  elmMain: 'src/Main.elm',
  elm: 'src/**/*.elm',
  css: 'src/css/**/*.css'
}

function swallowError (error) {
  console.log(error.toString());
  this.emit('end');
}

gulp.task('elm-init', elm.init);

gulp.task('elm', ['elm-init'], function() {
  return gulp.src(paths.elmMain)
    .pipe(elm())
    .on('error', swallowError)
    .pipe(rename("main.js"))
    .pipe(gulp.dest('dist/'));
});

gulp.task('html', function() {
  return gulp.src(paths.html)
    .pipe(gulp.dest('dist'))
});

gulp.task('css', function() {
  return gulp.src(paths.css)
    .pipe(concat('style.css'))
    .pipe(gulp.dest('dist/css'))
});

gulp.task('font', function() {
  return gulp.src('src/font/*')
    .pipe(gulp.dest('dist/font'))
});

gulp.task('img', function() {
  return gulp.src('src/img/*')
    .pipe(gulp.dest('dist/img'))
});

gulp.task('watch', function() {
  gulp.watch(paths.elm, ['elm']);
  gulp.watch(paths.html, ['html']);
  gulp.watch(paths.css, ['css']);
});

gulp.task('build', ['elm', 'html', 'css', 'font', 'img'])
gulp.task('default', ['build']);
