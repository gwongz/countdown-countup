gulp = require('gulp');
browserify = require('gulp-browserify');
sass = require('gulp-sass');
rename = require('gulp-rename');
browserSync = require('browser-sync');
reload = browserSync.reload;
runSequence = require('run-sequence');
del = require('del');
uglify = require('gulp-uglify');
plumber = require('gulp-plumber');
imagemin = require('gulp-imagemin');
notify = require('gulp-notify');
cssmin = require('gulp-cssmin');

onError = (err) ->
  console.log err


paths = 
  coffee: ['src/coffee/**/*'],
  sass: ['src/sass/**/*']


gulp.task('coffee', ->
  gulp.src('./src/coffee/app.coffee', { read:false })
    .pipe(browserify({
      transform: ['coffee-reactify'],
      extensions: ['.coffee']
    }))
    .pipe(uglify())
    .pipe(rename('app.js'))
    .pipe(gulp.dest('./app/static/js'))
    .pipe(reload({ stream: true}))
)


gulp.task('sass', -> 
  gulp.src('./src/sass/**/*')
    .pipe(sass())
    .pipe(cssmin())
    .pipe(gulp.dest('./app/static/css'))
    .pipe(reload({ stream: true}))
)



gulp.task('fonts', ->
  gulp.src('./src/fonts/**/*.{ttf,woff,eof,svg,woff2,css}')
    .pipe(plumber ({
      errorHandler: onError
    }))
    .pipe(gulp.dest('./app/static/fonts'))
)


gulp.task('images', ->
  gulp.src('./src/images/**/*')
    .pipe(imagemin())
    .pipe(gulp.dest('./app/static/images'))
)


gulp.task('reload', -> 
  gulp.src('./app/templates/*html')
    .pipe(reload({stream: true}))
)


gulp.task('serve', ['build'], -> 
  browserSync({
    proxy: 'localhost:5000',
    open: false
  });
  gulp.watch(paths.sass, ['sass'])
  gulp.watch(paths.coffee, ['coffee'])
  gulp.watch('./app/templates/*html', ['reload'])
)



gulp.task('clean', -> 
  del(['.app/static/**/*']);
)

# TODO: this should be able to take multiple messages
gulp.task('notify', ->
  gulp.src('./app')
    .pipe(notify({message: 'Build completed'}))
)

gulp.task('build', (callback) ->
  runSequence(
    'clean',
    'images',
    'fonts',
    'sass',
    'coffee',
    'notify',
    callback
  )
)


gulp.task('default', ['serve']);


