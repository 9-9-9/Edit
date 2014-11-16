'use strict'

angular.module('codoshop-sectionTabs', [])
	.directive 'sectionTabs', () ->
		templateUrl: 'components/sectionTabs/sectionTabs.html'
		link: (scope, el, attrs, ctrls) ->
			
			scope.tabs = scope.$eval attrs.tabs
			return