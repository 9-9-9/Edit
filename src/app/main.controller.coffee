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
	# .config ($stateProvider, $urlRouterProvider) ->

	# 	$stateProvider
	# 		.state 'column1'
	# 	return
	.directive 'codoshop', ($state, $stateParams, CodoshopFile) ->
		templateUrl: 'app/main.html'
		controller: ($scope) -> do ($s = $scope, vm = null) =>


			$scope.codoshopVM 	?= {}
			vm 					= $scope.codoshopVM
			vm.modules 			?= {}

			$scope.$state 			= $state
			$scope.$stateParams 	= $stateParams
			$scope.openFiles 	?= []
			$scope.projects 	?= []
			$scope.cmLookup 	= new WeakMap()

			@selectFile = do ($s) -> (f) ->
				for file in $s.openFiles when file.selected == true and file != f
					file.selected = false
				if f.selected != true
					f.selected = true

				f.click_order = ( [].concat($s.openFiles).sort( (a,b) -> 
					(b.click_order ? 0) - (a.click_order ? 0)
				).click_order ? 0 ) + 1

				return

			$scope.selectedFile = do ($s, arr = null) -> () ->
				arr = $s.openFiles.filter (el) ->
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
			vm.w = 0
			vm.h = 0
			# $scope.window =
			# 	w: 0
			# 	h: 0

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
					style:
						height: '200px'
						'flex-grow': 0
				,
					articles: [
						name: 'Outline'
						templateUrl: 'components/outline/outline.html'
					]
				]
				style:
					width: '180px'
			]

			vm.isSelected = (i, arr) ->
				i.selected == true or (not arr.some( (e,i,a) -> e.selected == true ) and i == arr[0])




			return
		link: (scope, el, attrs, ctrl) -> do (s = scope, el = $(el)) =>
			ctrl = [].concat(ctrl)[0]

			s.lhc = do (el) -> (multiple) ->
				console.log 'scope line height evaluated'
				(parseFloat(el.css('line-height')) * multiple) + 'px'


			# TODO: Performance?
			s.$watch do (el) -> () ->
				el.css 'width'
			,
			do (vm = scope.codoshopVM) -> (newV, oldV) ->
				if newV != 0
					vm.w = newV
				return

			s.$watch do (el) -> () ->
				el.css 'height'
			,
			do (vm = scope.codoshopVM) -> (newV, oldV) ->
				if newV != 0
					vm.h = newV
				return


			el.draggable
				handle: '> .codoshop-wrapper > .top'
			el.tooltip()

			

			s.inputFile = do (s, el, ctrl) -> (cb) -> do (fi = null) ->
				fi = el.find('input[ng-attr-codoshop-file-input]')

				fi[0].addEventListener 'change', do (fi, cb) -> (e) -> do (f = null, textType = null, fr = null) ->
					f = fi[0].files[0]
					# textType = /text.*/

					# if f.type.match textType
					if f
						fr = new FileReader()
						fr.onload = do (cb) -> (e) ->
							f = new CodoshopFile
								name: f.name
								mode: 'plaintext'
								content: fr.result
								type: 'file'
							cb f
							# s.openFiles.push f
							# ctrl.selectFile f
							# s.$apply()
							return
						try
							fr.readAsText f
						catch e
							console.log e
							cb()

					return

				fi.show()
				fi.click()
				fi.hide()
				return

			# TODO: replace with controller
			# s.inputFile = do (s, fi) -> ($e) ->
			# 	$e.stopPropagation()
			# 	fi.show()
			# 	fi.click()
			# 	fi.hide()
			# 	return

			return

			
	.directive 'topTabs', () ->
		require: '^codoshop'
		link: (scope, el, attrs, ctrl) ->
			ctrl = [].concat(ctrl)[0]

			scope.select = do (scope, ctrl) -> (i) -> do (f = scope.openFiles[i]) ->
				ctrl.selectFile f

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
					# scope.windo.w += 1
					# scope.windo.h += 1
					scope.$apply()
					return

			return


	.directive 'hsort', () ->
		(scope, el, attrs, ctrls) ->
			el.sortable
				axis: 'x'
				items: '> *:not([data-sort=false])'
			return
	.directive 'vsort', () ->
		(scope, el, attrs, ctrls) ->
			el.sortable
				axis: 'y'
			return




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


