var gulp = require('gulp');
var browserify = require('gulp-browserify');
var sass = require('gulp-sass');
var rename = require('gulp-rename');

gulp.task('coffee', function() {
  gulp.src('src/coffee/app.coffee', { read:false })
    .pipe(browserify({
      transform: ['coffee-reactify'],
      extensions: ['.coffee']
    }))
    .pipe(rename('app.js'))
    .pipe(gulp.dest('./app/static/js'))
});

gulp.task('sass', function() {
  gulp.src('src/sass/*scss')
    .pipe(sass())
    .pipe(gulp.dest('./app/static/css'));
});
gulp.task('scripts', function() {
  // single entry point to browserify
  gulp.src('src/js/*js')
    .pipe(browserify({
	insertGlobals: true,
	debug: !gulp.env.production
    }))
    .pipe(gulp.dest('./app/static/js'))
});

gulp.task('default', function() {
  // code for default task
});
