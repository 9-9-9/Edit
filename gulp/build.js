'use strict';

var gulp    = require('gulp');

var $      = require('gulp-load-plugins')({
  pattern: ['gulp-*', 'browser-sync', 'lazypipe', 'main-bower-files', 'uglify-save-license', 'del']
});

var reload = $.browserSync.reload;

var partials = {
  filename: 'templates.js',
  dest    : '.tmp/components/templates'
};

// initialize a lazypipe to process html
var processHtml = $.lazypipe()
  .pipe(function () {
    return $.if('**/*.jade', (
      $.lazypipe()
      .pipe($.jade, {
        locals: {},
        pretty: true
      })
      .pipe(gulp.dest,'.tmp')
    )());
  });

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


gulp.task('html:base', ['wiredep'], function () {
  return gulp.src('src/*.{html,jade}')
    .pipe(processHtml())
    .on('error', handleError)
});

gulp.task('html:partials', function () {
  return gulp.src('src/{app,components}/**/*.{html,jade}')
    .pipe(processHtml()) 
    .on('error', handleError)
});

gulp.task('html:partials:js', ['html:partials'], function () {
  return gulp.src(['.tmp/{app,components}/**/*.html', 'src/{app,components}/**/*.html'])
    .pipe($.minifyHtml({
      empty: true,
      spare: true,
      quotes: true
    }))
    .pipe($.angularTemplatecache(partials.filename, {module: 'codoshop'}))
    .pipe(gulp.dest(partials.dest))
    .on('error', handleError)
    .pipe($.size())
});

gulp.task('html', ['html:base', 'html:partials'], function () {
  return gulp.src(['.tmp/**/*.html', 'src/**/*.html'])
    .pipe($.size())
    .pipe(reload({stream:true}));
});

gulp.task('build:html', ['styles', 'scripts', 'html:base', 'html:partials:js'], function () {
  var htmlBaseFilter      = $.filter('*.html');
  var jsFilter            = $.filter('**/*.js');
  var cssFilter           = $.filter('**/*.css');
  var assets;

  return gulp.src(['.tmp/*.html', 'src/*.html'])

    .pipe($.inject(gulp.src(partials.dest + '/' + partials.filename), {
      read: false,
      starttag: '<!-- inject:partials -->',
      addRootSlash: false,
      addPrefix: '../'
    }))


    .pipe(assets = $.useref.assets())
    

    .pipe(jsFilter)
    .pipe($.ngAnnotate())
    .pipe($.uglify({preserveComments: $.uglifySaveLicense}))
    .pipe(jsFilter.restore())

    .pipe(cssFilter)
    .pipe($.csso())
    .pipe(cssFilter.restore())

    .pipe($.rev())
    .pipe(assets.restore())
    .pipe($.useref())
    .pipe($.revReplace())

    .pipe(htmlBaseFilter)
    .pipe($.minifyHtml({
      empty: true,
      spare: true,
      quotes: true
    }))
    .pipe(htmlBaseFilter.restore())

    .pipe(gulp.dest('dist'))
    .on('error', handleError)
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

gulp.task('build', ['build:html', 'images', 'fonts', 'misc']);
