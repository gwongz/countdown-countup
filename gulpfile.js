var gulp = require('gulp');
var browserify = require('gulp-browserify');
var sass = require('gulp-sass');
var rename = require('gulp-rename');
var browserSync = require('browser-sync');
var reload = browserSync.reload;
var runSequence = require('run-sequence');
var del = require('del');

var paths = {
  coffee: ['src/coffee/**/*'],
  sass: ['src/sass/**/*']
};

gulp.task('coffee', function() {
  gulp.src('src/coffee/app.coffee', { read:false })
    .pipe(browserify({
      transform: ['coffee-reactify'],
      extensions: ['.coffee']
    }))
    .pipe(rename('app.js'))
    .pipe(gulp.dest('./app/static/js'));
});

gulp.task('sass', function() {
  gulp.src('src/sass/**/*')
    .pipe(sass())
    .pipe(gulp.dest('./app/static/css'))
    .pipe(reload({ stream: true}));
});

gulp.task('serve', function() {
  browserSync({
    proxy: 'localhost:5000'
  });
  gulp.watch(paths.sass, ['sass']);
  gulp.watch(paths.coffee, ['coffee']);

});

gulp.task('clean', function() {
  del([
    './app/static/js/**',
    './app/static/css/**'
  ]);
});

gulp.task('build', function(callback){
  runSequence(
    'clean',
    'coffee',
    'sass',
    callback
  );
});


gulp.task('default', ['build', 'serve']);


