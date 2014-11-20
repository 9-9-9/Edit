'use strict';

var gulp = require('gulp');

// inject bower components
gulp.task('wiredep', function () {
  var wiredep = require('wiredep').stream;

  return gulp.src('src/index.jade')
    .pipe(wiredep({
      directory: 'bower_components',
      // bowerJson: '../../bower.json',
      exclude: [/bootstrap-sass-official/, /bootstrap.js/, /bootstrap.css/],
    }))
    .pipe(gulp.dest('src'));
});

gulp.task('wiredep:scss', function () {
  // var wiredep = require('wiredep').stream;

  // TODO: Enade wiredep for scss files.
});