'use strict'

handleError = (err) ->
	console.error err.toString()
	@emit 'end'
	return

gulp 	= require('gulp')
$ 		= require('gulp-load-plugins')(pattern: [
	'gulp-*'
	'browser-sync'
	'bun'
	'main-bower-files'
	'uglify-save-license'
	'del'
])
$.iff 	= require('gulp-if')

reload 	= $.browserSync.reload

# ********
# options
# ********
o 			= {}
o.module 	= 'codoshop'
o.dir =
	src: 'src'
	tmp: '.tmp'
	dist: 'dist'
o.dir.srcTest = o.dir.tmp + '/' + o.dir.src
o.dir.distTest = o.dir.tmp + '/' + o.dir.dist
o.partials =
	filename: 'templates.js'
	dest: o.dir.srcTest + '/components/templates'


# ********
# CSS task
# ********
gulp.task 'styles', ['wiredep'], ->
	gulp.src o.dir.src + '/**/*.css'

		.pipe $.addSrc(o.dir.src + '/**/*.scss')
		.pipe $.iff('**/*.scss', do () ->
				$.bun [
					$.rubySass
						style: 'expanded'
						sourcemap: false # this options is ignored due to bugs in gulp-ruby-sass v.0.7.1
					$.ignore.exclude '**/*.map' # remove map files created by bugs in gulp-ruby-sass v.0.7.1
				]
			)

		.pipe($.autoprefixer(browsers: ['last 1 version']))
		.on('error', handleError)
		.pipe(gulp.dest(o.dir.srcTest))
		.pipe($.size())
		.pipe(reload(stream: true))


# *******
# JS task
# *******
gulp.task 'scripts', ->
	gulp.src(o.dir.src + '/**/*.js')

		.pipe($.addSrc(o.dir.src + '/**/*.coffee'))
		.pipe $.iff('**/*.coffee', do () ->
				$.bun [
					$.coffee
						bare: false
					gulp.dest o.dir.srcTest
				]
			)

		.pipe $.jshint()
		.pipe $.jshint.reporter('jshint-stylish')
		.on 'error', handleError
		.pipe $.size()
		.pipe reload(stream: true)


# **********
# HTML tasks
# **********
# Process base html (files such as index.html and 404.html)
gulp.task 'html:base', ['wiredep'], ->
	gulp.src(o.dir.src + '/*.html')

	.pipe $.addSrc(o.dir.src + '/*.jade')
	.pipe $.iff('*.jade', do () ->
			$.bun [
				$.jade
					locals: {}
					pretty: true
				gulp.dest o.dir.srcTest
			]
		)

	.on('error', handleError)
	.pipe $.size()


# Process html partials (your html templates that live in the app and components directories)
gulp.task 'html:partials', ->
	gulp.src(o.dir.src + '/{app,components}/**/*.html')

	.pipe $.addSrc(o.dir.src + '/{app,components}/**/*.jade')
	.pipe $.iff('**/*.jade', do () ->
			$.bun [
				$.jade
					locals: {}
					pretty: true
				gulp.dest o.dir.srcTest
			]
		)

	.on('error', handleError)
	.pipe $.size()


# Convert your html partials to javascript. Only needed for distribution. This is run automatically for you when building.
gulp.task 'html:partials:js', ['html:partials'], ->
	gulp.src([
		o.dir.srcTest + '/{app,components}/**/*.html'
		o.dir.src + '/{app,components}/**/*.html'
	]).pipe($.minifyHtml(
		empty: true
		spare: true
		quotes: true
	)).pipe($.angularTemplatecache(o.partials.filename,
		module: o.module
	)).pipe(gulp.dest(o.partials.dest)).on('error', handleError).pipe $.size()


# Shortcut task to process all html for development with size logging and brower-sync reload.
gulp.task 'html', [
	'html:base'
	'html:partials'
], ->
	gulp.src([
			o.dir.srcTest + '/**/*.html'
			o.dir.src + '/**/*.html'
		])
		.pipe $.size()
		.pipe reload(stream: true)


# Build html for distribution
gulp.task 'build:html', [
	'styles'
	'scripts'
	'html:base'
	'html:partials:js'
], ->
	htmlBaseFilter = $.filter('*.html')
	jsFilter = $.filter('**/*.js')
	cssFilter = $.filter('**/*.css')
	assets = undefined
	
	gulp.src([
			o.dir.srcTest + '/*.html'
			o.dir.src + '/*.html'
		])

		# Inject partials
		.pipe($.inject(gulp.src(o.partials.dest + '/' + o.partials.filename),
			read: false
			starttag: '<!-- inject:partials -->'
			addRootSlash: false
			addPrefix: '../'

		))

		.pipe(assets = $.useref.assets())

		.pipe(jsFilter)
		.pipe($.ngAnnotate())
		.pipe($.uglify(preserveComments: $.uglifySaveLicense))
		.pipe(jsFilter.restore())

		.pipe(cssFilter)
		.pipe($.csso())
		.pipe(cssFilter.restore())

		# .pipe $.iff('**/codoshop.js', do () ->
		# 	$.bun [
		# 		gulp.dest(o.dir.dist)
		# 	]
		# )
		# .pipe $.ignore.exclude(o.dir.dist + '/**/*')

		.pipe($.rev())
		.pipe(assets.restore())
		.pipe($.useref())
		.pipe($.revReplace())

		.pipe(htmlBaseFilter)
		.pipe($.minifyHtml(
			empty: true
			spare: true
			quotes: true
		))
		.pipe(htmlBaseFilter.restore())

		.pipe(gulp.dest(o.dir.distTest))
		.on('error', handleError)
		.pipe($.size())
		.pipe(reload(stream: true))

gulp.task 'images', ->
	gulp.src o.dir.src + '/assets/images/**/*'
		.pipe $.cache($.imagemin(
			optimizationLevel: 3
			progressive: true
			interlaced: true
		))
		.pipe gulp.dest(o.dir.distTest + '/assets/images')
		.pipe $.size()
		.pipe reload(stream: true)

gulp.task 'fonts', ->
	gulp.src $.mainBowerFiles()
		.pipe $.filter('**/*.{eot,svg,ttf,woff}')
		.pipe $.flatten()
		.pipe gulp.dest(o.dir.distTest + '/fonts')
		.pipe $.size()
		.pipe reload(stream: true)

gulp.task 'misc', ->
	gulp.src o.dir.src + '/**/*.ico'
		.pipe(gulp.dest(o.dir.distTest))
		.pipe($.size())
		.pipe reload(stream: true)

gulp.task 'clean', (done) ->
	$.del [
		o.dir.tmp
	], done
	return

gulp.task 'copyToDist', (done) ->
	gulp.src o.dir.distTest + '/{scripts,styles}/' + o.module + '*'
		.pipe $.flatten()
		.pipe $.rename((path) ->
			path.basename = o.module
			return
		)
		.pipe $.size()
		.pipe gulp.dest(o.dir.dist)

gulp.task 'build', [
	'build:html'
	'images'
	'fonts'
	'misc'
	'copyToDist'
]
