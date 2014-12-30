'use strict'

angular
	.module 'codoshop-projects', ['codoshop-tree', 'codoshopDropMenu']
	.directive 'codoshopProjectsButtonRow', () ->
		templateUrl: 'components/projects/buttonRow.html'
		require: '^codoshop'
		controller: ($scope) -> do ($s = $scope) =>

			# fi =$(el).find('input')

			# fi[0].addEventListener 'change', (e) -> do (file = null, textType = null, fr = null) ->
			# 	file = fi.files[0]
			# 	textType = /text.*/

			# 	if file.type.match(textType)
			# 		fr = new FileReader()
			# 		fr.onload = (e) ->
			# 			# fileDisplayArea.innerText = reader.result
			# 			return
			# 		fr.readAsText file
			# 	return

			# @add = do (s = scope, fi) -> (e) ->
			# 	e.stopPropagation()
			# 	fi.show()
			# 	fi.click()
			# 	fi.hide()
			# 	return



			$s.move = do (ps = $s.projects) -> (i, w) ->
				
				if w < 0
					w == 0
				else if w > ps.length - 1 
					w == ps.length - 1

				if i != w
					pp = ps.splice(i, 1)[0]
					ps.splice w, 0, pp

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
		# controller: ($scope) ->
		# 	return
		link: (scope, el, attrs, ctrls) ->
			# ctrl = [].concat(ctrls)[0]

			Array::move = (from, to) ->
				@splice to, 0, @splice(from,1)[0]

			return

	.directive 'codoshopProjectView', () ->
		templateUrl: 'components/projects/project.html'
		require: '^codoshop'
		controller: ($scope) -> do ($s = $scope) ->
			# $s.dirTree ?= []
			return
		link: (scope, el, attrs, ctrl) -> do (s = scope, el = $(el)) ->
			ctrl = [].concat(ctrl)[0]

			s.openToggle = do (s, ctrl) -> (sts = s.project.status, d = s.project.dirTree) ->
				# if d and d.length > 0
				# ctrl.scrollTop = $(el).parent().scrollTop()
				s.project.status = if sts == 'expanded' then 'contracted' else 'expanded'
				return

			s.add = do (s) -> (f) ->
				s.inputFile (f) ->
					s.project.dirTree ?= []
					s.project.dirTree.push f
					s.$apply()
				return

			s.open = do (s) -> (n) ->
				if n.type == 'file'
						if s.openFiles.indexOf(n) == -1
							s.openFiles.push n
						else
							console.log 'file is already open'
					ctrl.selectFile n
				return


			s.openSettingsMenu = do (s) -> ($e) ->
				$e.preventDefault()
				$e.stopPropagation()

				s.codoshopVM.dropMenu.items = [
					label: 'add folder/files...'
					'ng-click': ($e) ->
						$e.stopPropagation()
						s.inputFile (f) ->
							s.project.dirTree ?= []
							s.project.dirTree.push f
							s.$apply()
							return
						return
				,
					label: 'rename...'
					'ng-click': 'rename()'
				,
					label: 'reveal in finder...'
					'ng-click': 'reveal()'
				,
					label: 'remove'
					'ng-click': 'remove()'
				]
				s.codoshopVM.dropMenu.show = true
				return

			# s.openFileMenu = do (s) -> ($e, f) ->
			# 	$e.preventDefault()
			# 	$e.stopPropagation()

			# 	s.codoshopVM.dropMenu.items = [
			# 		label: 'reveal in finder...'
			# 		'ng-click': 'reveal()'
			# 	,
			# 		label: 'remove'
			# 		'ng-click': 'remove()'
			# 	]
			# 	s.codoshopVM.dropMenu.show = true
			# 	return


			if s.$last
				$(el).css 'height', $(el).parent().height()

			$(el).bind 'animationProgress', do (el = $(el)) -> () ->
				# console.log scope.$last
				if s.$last
					el.css 'height', el.parent().height()

				return

			# TODO: performance
			s.$watchCollection 'projects', () ->
				if s.project != s.projects[s.projects.length - 1]
					el.css 'height', 'auto'
				else
					el.css 'height', el.parent().height()
				return

			return