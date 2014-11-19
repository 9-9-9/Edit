'use strict';

var gulp = require('gulp');

var util = require('util');

var browserSync = require('browser-sync');

var middleware = require('./proxy');

function browserSyncInit(baseDir, bower) {
	return browserSync({
        server: {
            baseDir: baseDir,
            routes: (bower == true ? {
        		"/bower_components": "bower_components"
    		} : null),
        },
        
        middleware: middleware
    });
}

// gulp.task('browser-sync', function() {
    
// });

gulp.task('serve', ['watch'], function () {
	browserSyncInit(['.tmp','src'], true);
});

gulp.task('serve:dist', ['build'], function () {
  browserSyncInit('dist', true);
});

gulp.task('serve:e2e', function () {
  browserSyncInit(['src', '.tmp'], false);
});

gulp.task('serve:e2e-dist', ['watch'], function () {
  browserSyncInit('dist', false);
});

// **********************************************************************************************************************

// function browserSyncInit(baseDir, files, browser) {
//   browser = browser === undefined ? 'default' : browser;

//   var routes = null;
//   if(baseDir === 'src' || (util.isArray(baseDir) && baseDir.indexOf('src') !== -1)) {
//     routes = {
//		// Should be '/bower_components': '../bower_components'
//      // Waiting for https://github.com/shakyShane/browser-sync/issues/308
//       '/bower_components': 'bower_components'
//     };
//   }

//   browserSync.instance = browserSync.init(files, {
//     startPath: '/index.html',
//     server: {
//       baseDir: baseDir,
//       middleware: middleware,
//       routes: routes
//     },
//     browser: browser
//   });

// }

// gulp.task('serve', ['watch'], function () {
//   browserSyncInit([
//     'src',
//     '.tmp'
//   ], [
//     '.tmp/{app,components}/**/*.css',
//     'src/assets/images/**/*',
//     'src/*.html',
//     'src/{app,components}/**/*.html',
//     '.tmp/{app,components}/**/*.js'
//   ]);
// });

// gulp.task('serve:dist', ['build'], function () {
//   browserSyncInit('dist');
// });

// gulp.task('serve:e2e', function () {
//   browserSyncInit(['src', '.tmp'], null, []);
// });

// gulp.task('serve:e2e-dist', ['watch'], function () {
//   browserSyncInit('dist', null, []);
// });
