var gulp = require('gulp');
var browserify = require('gulp-browserify');
var sass = require('gulp-sass');
var rename = require('gulp-rename');
var browserSync = require('browser-sync');
var reload = browserSync.reload;
var runSequence = require('run-sequence');
var del = require('del');
var uglify = require('gulp-uglify');
var plumber = require('gulp-plumber');
var onError = function(err){
  console.log(err);
}

var paths = {
  coffee: ['src/coffee/**/*'],
  sass: ['src/sass/**/*']
};

gulp.task('coffee', function() {
  return gulp.src('./src/coffee/app.coffee', { read:false })
    .pipe(browserify({
      transform: ['coffee-reactify'],
      extensions: ['.coffee']
    }))
    .pipe(rename('app.js'))
    .pipe(uglify())
    .pipe(gulp.dest('./app/static/js'))
    .pipe(reload({ stream: true}));
});

gulp.task('sass', function() {
  return gulp.src('./src/sass/**/*')
    .pipe(sass())
    .pipe(gulp.dest('./app/static/css'))
    .pipe(reload({ stream: true}));
});

gulp.task('fonts', function(){
  return gulp.src('./src/fonts/**/*')
    .pipe(plumber ({
      errorHandler: onError
    }))
    .pipe(gulp.dest('./app/static/fonts'));
});

gulp.task('reload', function() {
  gulp.src('./app/templates/*html')
    .pipe(reload({ stream: true}));
});

gulp.task('serve', ['build'], function() {
  browserSync({
    proxy: 'localhost:5000',
    open: false
  });
  // gulp.watch(paths.sass, ['sass']);
  // gulp.watch(paths.coffee, ['coffee']);
  gulp.watch('./app/templates/*html', ['reload']);

});

gulp.task('clean', function() {
  return del([
    './app/static/js/**',
    './app/static/css/**',
    './app/static/fonts/**/*'
  ]);
});

gulp.task('build', function(callback){
  runSequence(
    'clean',
    'fonts',
    'sass',
    'coffee',
    callback
  );
});


gulp.task('default', ['serve']);


