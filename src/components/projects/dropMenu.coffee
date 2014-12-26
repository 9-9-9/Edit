'use strict'

angular
	.module 'codoshopDropMenu'
	.config ($stateProvider, $urlRouterProvider) ->

		$stateProvider.state 'projectsDropMenu',
			views:
				dropMenu:
					templateUrl: 'components/projects/dropMenu.html'

		return
	.directive 'codoshopProjectsDropMenu', () ->
		# templateUrl: 'components/projects/dropMenu.html'
		controller: ($scope) ->

			$scope.add () ->

				return

			$scope.rename () ->

				return

			$scope.reveal () ->

				return

			$scope.remove () ->

				return

			return