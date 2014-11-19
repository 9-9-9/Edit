'use strict';

var gulp    = require('gulp');

var $      = require('gulp-load-plugins')({
  pattern: ['gulp-*', 'browser-sync', 'main-bower-files', 'uglify-save-license', 'del']
});

var reload = $.browserSync.reload;

function handleError(err) {
  console.error(err.toString());
  this.emit('end');
}

gulp.task('styles', ['wiredep'],  function () {
  var scssFilter = $.filter('**/*.scss')

  return gulp.src('src/**/*.{css,scss}')
    .pipe(scssFilter)
    .pipe($.rubySass({
      sourcemap: false,
      sourcemapPath: false
    }))
    .pipe($.ignore.exclude('**/*.map'))
    .pipe(scssFilter.restore())
    .pipe($.autoprefixer({
      browsers: ['last 1 version']
    }))
    .on('error', handleError)
    .pipe(gulp.dest('.tmp'))
    .pipe($.size())
    .pipe(reload({stream:true}));
});


gulp.task('scripts', function () {
  var coffeeFilter = $.filter('**/*.coffee')

  return gulp.src(['src/**/*.{js,coffee}'])
    .pipe(coffeeFilter)
    .pipe($.coffee({bare: false}))
    .pipe(coffeeFilter.restore())
    .pipe($.jshint())
    .pipe($.jshint.reporter('jshint-stylish'))
    .on('error', handleError)
    .pipe(gulp.dest('.tmp'))
    .pipe($.size())
    .pipe(reload({stream:true}));
});


gulp.task('html', function () {
  var jadeFilter = $.filter('**/*.jade')

  return gulp.src('src/**/*.{html,jade}')
    .pipe(jadeFilter)
    .pipe($.jade({
      locals: {}
    }))
    .pipe(gulp.dest('.tmp'))
    .pipe(jadeFilter.restore())
    .on('error', handleError)
    .pipe($.size())
    .pipe(reload({stream:true}));
});

gulp.task('htmlForDist', ['styles', 'scripts', 'html'], function () {
  var htmlFilter = $.filter('*.html');
  var jsFilter = $.filter('{app,components}/**/*.js');
  var cssFilter = $.filter('{app,components}/**/*.css');
  var assets;

  return gulp.src('{.tmp,src}/**/*.html')
    .pipe($.minifyHtml({
      empty: true,
      spare: true,
      quotes: true
    }))
    .pipe($.angularTemplatecache('templates.js', {module: 'codoshop'}))
    .pipe(gulp.dest('.tmp/components/templates'))
    .pipe($.inject(gulp.src('.tmp/components/templates/templates.js'), {
      read: false,
      starttag: '<!-- inject:partials -->',
      addRootSlash: false,
      addPrefix: '../'
    }))
    .pipe(assets = $.useref.assets())
    
    .pipe($.rev())

    .pipe(jsFilter)
    .pipe($.ngAnnotate())
    .pipe($.uglify({preserveComments: $.uglifySaveLicense}))
    .pipe(jsFilter.restore())

    .pipe(cssFilter)
    .pipe($.csso())
    .pipe(cssFilter.restore())

    .pipe(assets.restore())
    .pipe($.useref())

    .pipe($.revReplace())
    .pipe(htmlFilter)
    .pipe($.minifyHtml({
      empty: true,
      spare: true,
      quotes: true
    }))
    .pipe(htmlFilter.restore())

    .pipe(gulp.dest('dist'))
    .pipe($.size())
    .pipe(reload({stream:true}));
});

gulp.task('images', function () {
  return gulp.src('src/assets/images/**/*')
    .pipe($.cache($.imagemin({
      optimizationLevel: 3,
      progressive: true,
      interlaced: true
    })))
    .pipe(gulp.dest('dist/assets/images'))
    .pipe($.size())
    .pipe(reload({stream:true}));
});

gulp.task('fonts', function () {
  return gulp.src($.mainBowerFiles())
    .pipe($.filter('**/*.{eot,svg,ttf,woff}'))
    .pipe($.flatten())
    .pipe(gulp.dest('dist/fonts'))
    .pipe($.size())
    .pipe(reload({stream:true}));
});

gulp.task('misc', function () {
  return gulp.src('src/**/*.ico')
    .pipe(gulp.dest('dist'))
    .pipe($.size())
    .pipe(reload({stream:true}));
});

gulp.task('clean', function (done) {
  $.del(['.tmp', 'dist'], done);
});

gulp.task('build', ['html', 'images', 'fonts', 'misc']);
