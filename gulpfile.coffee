'use strict'

gulp = require('gulp')

require('require-dir') './gulp'

gulp.task 'default', ['clean'], ->
	gulp.start 'build'
	return

