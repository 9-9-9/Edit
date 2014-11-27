'use strict';

var gulp = require('gulp');

var browserSync = require('browser-sync');

var middleware = require('./proxy');

var bowerRoute = {
  "/bower_components": "bower_components"
}

function browserSyncInit(baseDir, routes) {
  return browserSync({
        server: {
            baseDir: baseDir,
            routes: routes
        },
        middleware: middleware
    });
}

gulp.task('serve', ['watch'], function () {
  browserSyncInit(['.tmp/src', 'src'], bowerRoute);
});

gulp.task('serve:dist', ['build'], function () {
  browserSyncInit('.tmp/dist', bowerRoute);
});

gulp.task('serve:e2e', function () {
  browserSyncInit(['.tmp/src', 'src'], null);
});

gulp.task('serve:e2e-dist', ['watch'], function () {
  browserSyncInit('.tmp/dist', null);
});
