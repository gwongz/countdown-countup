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
var imagemin = require('gulp-imagemin');
var notify = require('gulp-notify');
var cssmin = require('gulp-cssmin');

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
    .pipe(uglify())
    .pipe(rename('app.js'))
    .pipe(gulp.dest('./app/static/js'))
    .pipe(reload({ stream: true}));
});

gulp.task('sass', function() {
  return gulp.src('./src/sass/**/*')
    .pipe(sass())
    // .pipe(cssmin())
    .pipe(gulp.dest('./app/static/css'))
    .pipe(reload({ stream: true}));
});

// broken task
gulp.task('fonts', function(){
  return gulp.src('./src/fonts/**/*.{ttf,woff,eof,svg,woff2,css}')
    .pipe(plumber ({
      errorHandler: onError
    }))
    .pipe(gulp.dest('./app/static/fonts'));
});

gulp.task('images', function(){
  return gulp.src('./src/images/**/*')
    .pipe(imagemin())
    .pipe(gulp.dest('./app/static/images'))
    .pipe(notify({message: 'Image task complete'}));
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
  gulp.watch(paths.sass, ['sass']);
  gulp.watch(paths.coffee, ['coffee']);
  gulp.watch('./app/templates/*html', ['reload']);

});

gulp.task('clean', function() {
  return del([
    './app/static/js/**',
    './app/static/css/**',
    './app/static/images/**',
    './app/static/fonts/**'
  ]);
});

gulp.task('build', function(callback){
  runSequence(
    'clean',
    'images',
    'fonts',
    'sass',
    'coffee',
    callback
  );
});


gulp.task('default', ['serve']);


