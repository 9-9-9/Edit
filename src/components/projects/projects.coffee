'use strict'

angular.module('codoshop-projects', ['codoshop-tree', 'codoshopDropMenu'])
	.directive 'codoshopProjectsButtonRow', () ->
		templateUrl: 'components/projects/buttonRow.html'
		require: '^codoshop'
		controller: ($scope) ->

			$scope.openSettingsMenu = do (s = $scope) -> ($event) ->
				s.$state.go 'projectsDropMenu'
				s.codoshopVM.dropMenu.show = true
				s.codoshopVM.dropMenu.anchor = $($event.currentTarget)
				return

			return
		link: (scope, el, attrs, ctrls) ->
			ctrl = [].concat(ctrls)[0]

			scope.newProject = do (ctrl) -> () ->
				ctrl.newProject()
				return


			scope.toggleAll = do (scope) -> (expanded = [], contracted = []) ->

				scope.projects.every do (expanded, contracted) -> (v,i,a) -> do (sts = v.status, d = v.dirTree) ->
					if d and d.length > 0
						expanded.push 	v if sts == 'expanded'
						contracted.push v if sts != 'expanded'
					true

				v.status = 'contracted' for v in expanded
				v.status = 'expanded' for v in contracted when expanded.length == 0

				return

			scope.expandedProjects = () ->
				scope.projects.filter (v,i,a) -> do (sts = v.status, d = v.dirTree) ->
					d and d.length > 0 and sts == 'expanded'

			scope.contractedProjects = () ->
				scope.projects.filter (v,i,a) -> do (sts = v.status, d = v.dirTree) ->
					d and d.length > 0 and sts != 'expanded'
			return
	.directive 'codoshopProjects', () ->
		controller: ($scope) ->
			return
		link: (scope, el, attrs, ctrls) ->
			# ctrl = [].concat(ctrls)[0]

			Array::move = (from, to) ->
				@splice to, 0, @splice(from,1)[0]
			return
	.directive 'codoshopProject', () ->
		# controller: ($scope) ->
		# 	$scope.status =
		# 		opened: false
			
		# 	return
		require: '^codoshopProjects'
		link: (scope, el, attrs, ctrls) ->
			ctrl = [].concat(ctrls)[0]

			scope.openToggle = do (s = scope, ctrl) -> (sts = s.project.status, d = s.project.dirTree) ->
				if d and d.length > 0
					ctrl.scrollTop = $(el).parent().scrollTop()
					s.project.status = if sts == 'expanded' then 'contracted' else 'expanded'
				return

			

			$(el).bind 'animationProgress', do (ctrl, el) -> () ->
				# ctrl.adjust $(el).parent()
				ctrl.adjust()
				return

			return
	.directive 'codoshopSpacer', () ->
		controller: ($scope) ->
			return
		require: '^codoshopProjects'
		link: (scope, el, attrs, ctrls) ->
			ctrl = [].concat(ctrls)[0]

			ctrl.adjust = do (el, ctrl) -> () -> do (projects = null, lastProject = null, lastProjectHeight = null, scrollTop = null) ->

				projects 			= $(el).siblings('.codoshop-project')
				lastProject 		= projects.last()
				lastProjectHeight 	= lastProject.height()

				if lastProjectHeight
					
					$(el).css 'height', ($(el).parent().height() - lastProjectHeight) + 1 + 'px'

					scrollTop = ctrl.scrollTop
					$(el).parent().scrollTop scrollTop if scrollTop

				$(el).height()

			# scope.$watchCollection 'projects', do (ctrl) -> (newValue, oldValue) ->
			# 	# ctrl.adjust()
			# 	return
			do (el, ctrl) ->
				scope.$watchGroup(
					[ (() -> do (projects = null) ->
						# projects = $(el).parent().children('.codoshop-project')
						projects = $(el).siblings('.codoshop-project')
						projects.last().height()
					), () ->
						$(el).parent().height()
					]
				,	() -> do (newHeight = null) ->
						# projects = $(el).parent().children('.codoshop-project')
						newHeight = ctrl.adjust()
						# console.log newHeight
						return
				)
				return
			

			return