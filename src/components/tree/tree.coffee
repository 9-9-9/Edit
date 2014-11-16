'use strict'

###*
 # @ngdoc function
 # @name codoshopApp.controller:AboutCtrl
 # @description
 # # AboutCtrl
 # Controller of the codoshopApp
###
angular.module('codoshop-tree', ['ngAnimate'])
	.controller 'zTree', ($scope) ->
		$scope.awesomeThings = [
			'HTML5 Boilerplate'
			'AngularJS'
			'Karma'
		]
		return
	.directive 'node', () ->
		(scope, el, attrs) -> 

			scope.click = do (scope) -> () ->
				switch scope.node.status
					when 'closed'
						scope.node.status = 'open'
					else
						scope.node.status = 'closed'
				return

			return
	