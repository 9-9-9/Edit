'use strict'

###
 # @ngdoc function
 # @name codoshop
 # @description
 # codoshop module
###

angular
	.module 'codoshop'
	# .run ($rootScope, $state, $stateParams) ->

	# 	return
	.directive 'codoshop', ($state, $stateParams) ->
		templateUrl: 'app/main.html'
		controller: ($scope) -> do (vm = null) =>


			$scope.codoshopVM 	?= {}
			vm 					= $scope.codoshopVM
			vm.modules 			?= {}

			$scope.$state 			= $state
			$scope.$stateParams 	= $stateParams
			$scope.openFiles 	?= []
			$scope.projects 	?= []
			$scope.cmLookup 	= new WeakMap()

			@selectFile = do ($scope) -> (f) ->
				for file in $scope.openFiles when file.selected == true and file != f
					file.selected = false
				if f.selected == false
					f.selected = true

				f.click_order = ( [].concat($scope.openFiles).sort( (a,b) -> 
					(b.click_order ? 0) - (a.click_order ? 0)
				).click_order ? 0 ) + 1

				return

			$scope.selectedFile = do ($scope, arr = null) -> () ->
				arr = $scope.openFiles.filter (el) ->
					el.selected == true
				if arr.length > 0 then arr[0] else null
				

			$scope.$watchCollection 'openFiles', do (ctrl = @) -> (newItems, oldItems, scope) ->

				missingItems = oldItems.filter do (newItems) -> (oldI) ->
					newItems.indexOf(oldI) == -1

				addedItems = newItems.filter do (oldItems) -> (newI) ->
					oldItems.indexOf(newI) == -1


				newItems.every do (oldItems) -> (el) ->
					if el.selected == true and oldItems.indexOf(el) == -1
						ctrl.selectFile el
						return false
					true

				if not scope.selectedFile() and scope.openFiles.length > 0
					ctrl.selectFile scope.openFiles[0]
					# if scope.openFiles.length > 1 && f.selected == true
					# if i + 1 == scope.openFiles.length
					# 	scope.openFiles[i - 1].selected = true
					# else
					# 	scope.openFiles[i + 1].selected = true

				# selectedFile = scope.openFiles.filter (el) ->

				# 	false


				return

			$scope.newFile = do ($scope, newFile = null) -> () ->
				newFile = 
					name: 'untitled'
					mode: 'plaintext'
					content:
						"""
						"""
					selected: true
				$scope.openFiles.push newFile
				return

			@newProject = do ($scope) -> () -> do (newProject = null) ->
				$scope.projects.push
					name: 'Untitled'
				return

			# TODO: See if it's possible to avoid using scope here
			$scope.windo =
				w: 0
				h: 0

			# ViewModel - This determines how many columns, how many sections in each column, etc.
			vm.columns ?= [

				sections: [
					articles: [
						name: 'Projects'
						templateUrl: 'components/projects/projects.html'
					,
						name: 'Other'
					]
				]
				style:
					width: '220px'
			,
				sections: [
					tabs: false
					articles: [
						name: 'Text Editor'
						templateUrl: 'components/textEditor/textEditor.html'
					]
				]
				class: 'fc-g-1'
			,
				sections: [
					articles: [
						name: 'Colors'
						templateUrl: 'components/colors/colors.html'
					]
				,
					articles: [
						name: 'Outline'
						templateUrl: 'components/outline/outline.html'
					]
				]
			]

			vm.isSelected = (i, arr) ->
				i.selected == true or (not arr.some( (e,i,a) -> e.selected == true ) and i == arr[0])



			return
		link: (scope, el, attrs, ctrls) ->
			scope.lhc = do (el) -> (multiple) ->
				console.log 'scope line height evaluated'
				(parseFloat(el.css('line-height')) * multiple) + 'px'



			el.draggable
				handle: '> .codoshop-wrapper > .top'
			el.tooltip()
			return

			
	.directive 'topTabs', () ->
		require: '^codoshop'
		link: (scope, el, attrs, ctrl) ->
			ctrl = [].concat(ctrl)[0]
			# scope.isSelected = do (scope) -> (i) ->
			# 	scope.openFiles[i].selected == true

			# scope.clickOrderSort = (openFiles) -> 
			# 	[].concat(openFiles).sort (a,b) -> 
			# 		(b.click_order ? 0) - (a.click_order ? 0)

			scope.select = do (scope, ctrl) -> (i) -> do (f = scope.openFiles[i]) ->
				ctrl.selectFile f
				# if f.selected == false
				# 	# for file in scope.openFiles when file.selected == true
				# 	# 	file.selected = false
				# 	# f.selected = true
				# 	# f.click_order = (scope.clickOrderSort(scope.openFiles)[0].click_order ? 0) + 1
				# 	f.selected = true
				return

			scope.close = do (scope) -> (i) -> do (f = scope.openFiles[i]) ->
				scope.openFiles.splice i, 1
				return




			return

	.directive 'resizable', () ->
		link: (scope, el, attrs, ctrls) -> do (direction = attrs.resizable) ->

			el.resizable
				handles: direction
				resize: do (direction) -> (event, ui) ->
					if direction == 'w'
						ui.position.left = ui.originalPosition.left
					scope.windo.w += 1
					scope.windo.h += 1
					scope.$apply()
					return

			return
	.directive 'hsort', () ->
		(scope, el, attrs) ->
			el.sortable
				axis: 'x'
			return
	.directive 'vsort', () ->
		(scope, el, attrs) ->
			el.sortable
				axis: 'y'
			return
	# .directive 'codemirror', () ->
	# 	require: '^codoshop'
	# 	link: (scope, el, attrs, ctrl) -> do (resize = null, mode = scope.file.mode) ->

			


	# 		return



.animation '.animate-slide', () ->
	addClass: (el, className, done) ->
		if className == 'ng-hide'
			
			$(el).slideUp
				duration: 150
				complete: done
				progress: do (el) -> (p,n,r) ->
					$(el).trigger 'animationProgress'
					return

		(isCancelled) ->
			# $(el).stop() if isCancelled
			return
	removeClass: (el, className, done) ->
		if className == 'ng-hide'

			$(el).hide() if $(el).css('display') == 'none'
			$(el).slideDown
				duration: 150
				complete: done
				progress: do (el) -> (p,n,r) ->
					$(el).trigger 'animationProgress'
					return

		(isCancelled) ->
			# $(el).stop() if isCancelled
			return
# .factory 'windows', () -> do (window = {}) ->
# 	window.openFiles = []
# 	[window]


