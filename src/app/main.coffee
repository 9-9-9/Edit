'use strict'

###*
 # @ngdoc function
 # @name codoshop
 # @description
 # codoshop module
###

angular
	.module('codoshop', [
		'ngAnimate',
		'ngCookies',
		'ngResource',
		'ngRoute',
		'ngSanitize',
		'ngTouch',

		'ui.router',
		'ui.codemirror',
		
		'codoshop-tree',
		'codoshopDropMenu',
		'codoshop-sectionTabs',
		'codoshop-projects',
		'codoshop-colors',
		'codoshop-outline',
		'codoshopTextEditor'
	])