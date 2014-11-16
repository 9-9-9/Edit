'use strict'

angular.module('codoshop-projects', ['codoshop-tree'])
	.directive 'buttonRow', () ->
		templateUrl: 'components/projects/buttonRow.html'
	.directive 'codoshopProjects', () ->
		controller: ($scope) ->

			return
		link: (scope, el, attrs, ctrls) ->
			# ctrl = [].concat(ctrls)[0]


			return
	.directive 'codoshopProject', () ->
		controller: ($scope) ->
			$scope.status =
				opened: false
			
			return
		require: '^codoshopProjects'
		link: (scope, el, attrs, ctrls) ->
			ctrl = [].concat(ctrls)[0]
			# scope.status =
			# 	opened: false
			scope.openToggle = do (scope) -> (o = scope.project.status) ->
				scope.project.status = if o == 'expanded' then 'contracted' else 'expanded'
				return

			

			$(el).bind 'animationProgress', do (ctrl, el) -> () ->
				# ctrl.adjust $(el).parent()
				return

			# ctrl.adjust el
			return
	.directive 'codoshopSpacer', () ->
		controller: ($scope) ->
			return
		link: (scope, el, attrs, ctrls) ->
			ctrl = [].concat(ctrls)[0]

			ctrl.adjust = do (el) -> () -> do (projects = null, huh = null) ->
				projects = $(el).parent().children('.codoshop-project')
				huh = $(el).parent().height() - projects.last().height()
				$(el).css 'height', huh + 1 + 'px'
				# spacers = $(el).children('.codoshop-project + div')
				
				# console.log lastProject.css 'display'
				# console.log spacers.last().css 'display'
				console.log huh + 1 + 'px'
				return

			scope.$watchCollection 'projects', do (ctrl) -> (newValue, oldValue) ->
				ctrl.adjust()
				return

			return