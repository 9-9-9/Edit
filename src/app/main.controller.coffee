'use strict'

###
 # @ngdoc function
 # @name codoshop
 # @description
 # codoshop module
###

angular
	.module('codoshop')
	.directive 'codoshopp', () ->
		templateUrl: 'app/main.html'
		controller: ($scope) -> do (vm = null) =>

			$scope.codoshopVM 	?= {}
			vm 					= $scope.codoshopVM
			vm.modules 			?= {}

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
				# console.log newItems
				# console.log oldItems
				# $scope.$watch 'openFiles['+pos+'].start_time', () ->

				# 	return
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
				],
			,
				sections: [
					tabs: false
					articles: [
						name: 'Text Editor'
						templateUrl: 'components/textEditor/textEditor.html'
					]
				]
				class: "fc-g-1"
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



			return
		link: (scope, el, attrs, ctrls) ->
			scope.lhc = do (el) -> (multiple) ->
				console.log 'scope line height evaluated'
				(parseFloat(el.css('line-height')) * multiple) + 'px'



			el.draggable
				handle: '> .codoshop-wrapper > .top'
			el.tooltip()
			return

			
	.directive 'leftTabs', () ->
		(scope, el, attrs) ->

			scope.leftTabs =
				model: [
					title: 'Project'
					selected: true
				,
					title: 'File'
					selected: false
				]
			return
	.directive 'rightTabs1', () ->
		(scope, el, attrs) ->

			scope.rightTabs1 =
				model: [
					title: 'Colors'
					selected: true
				]
			return
	.directive 'rightTabs2', () ->
		(scope, el, attrs) ->

			scope.rightTabs2 =
				model: [
					title: 'Outline'
					selected: true
				]
			return
	.directive 'topTabs', () ->
		require: '^codoshopp'
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
				# if scope.openFiles.length > 1 && f.selected == true
				# 	if i + 1 == scope.openFiles.length
				# 		scope.openFiles[i - 1].selected = true
				# 	else
				# 		scope.openFiles[i + 1].selected = true
				scope.openFiles.splice i, 1
				return




			return

	.directive 'resizable', () ->
		# require: '^codoshopp'
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
	.directive 'codemirror', () ->
		require: '^codoshopp'
		link: (scope, el, attrs, ctrl) -> do (resize = null, mode = scope.file.mode) ->

			ctrl = [].concat(ctrl)[0]
			# resize = do (el, w = null, h = null) -> (myCM) ->
			# 	w = el.parent().css('width')
			# 	h = el.parent().css('height')
			# 	el.css 'width', w
			# 	el.css 'height', h
			# 	return


			# scope.$watch 'windo.w', (newVal, oldVal, scope) ->
			# 	if scope.file.selected == true && scope.myCM
			# 		resize()
			# 	return


			# if mode == 'scss'
			# 	mode = 
			# 		name: 'css'
			# 		scss: true
			# else if mode == 'html'
			# 	mode = 'htmlmixed'
			# else if mode == 'js'
			# 	mode = 'javascript'

			##### Replace scope with ctrl
			# scope.myCM = CodeMirror( el[0],
			# 	value:  scope.file.content
			# 	mode: mode
			# 	lineNumbers: true
			# 	foldGutter: true
			# 	gutters: ['CodeMirror-linenumbers', "CodeMirror-foldgutter"]
			# 	theme: 'night'
			# )
			# scope.myCM.setSize '100%', '100%'
			# resize()
			# scope.myCM.refresh()
			# scope.cmLookup.set scope.file, scope.myCM

			scope.editorOptions =
				value		: scope.file.content
				mode 		: mode
				lineNumbers : true
				foldGutter 	: true
				gutters		: ['CodeMirror-linenumbers', 'CodeMirror-foldgutter']
				theme		: 'night'


			return

.directive 'projectMenu', () ->
	controller: ($scope) ->
		$scope.status =
			opened: false
		return
	link: (scope, el, attrs) ->
		# scope.status =
		# 	opened: false
		scope.openToggle = do (scope) -> (o = scope.project.status) ->
			scope.project.status = if o == 'expanded' then 'contracted' else 'expanded'
			return
		return

.animation '.animate-slide', () ->
	addClass: (el, className, done) ->
		if className == 'ng-hide'
			
			$(el).slideUp
				duration: 200
				complete: done

		(isCancelled) ->
			# $(el).stop() if isCancelled
			return
	removeClass: (el, className, done) ->
		if className == 'ng-hide'

			# $(el).hide()
			$(el).slideDown
				duration: 200
				complete: done

		(isCancelled) ->
			# $(el).stop() if isCancelled
			return
# .factory 'windows', () -> do (window = {}) ->
# 	window.openFiles = []
# 	[window]


