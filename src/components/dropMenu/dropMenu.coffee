'use strict'

angular
	.module 'codoshopDropMenu', []
	.directive 'codoshopDropMenu', () ->
		controller: ($scope) -> do (dm = null) =>

			$scope.codoshopVM.dropMenu ?= {}

			dm 			= $scope.codoshopVM.dropMenu
			dm.show 	?= false
			dm.anchor 	?= null
			dm.items 	?= []

			# TODO: Performance?
			@mE = null
			@mX = 0
			@mY = 0
			$( document ).mousemove do (ctrl = @) -> (e) ->
				if e
					ctrl.mE = e
					ctrl.mX = e.pageX
					ctrl.mY = e.pageY
				return

			# $('body').draggable
			# 	drag: (event, ui) ->
			# 		return false

			return
		link: (scope, el, attrs, ctrls) ->
			ctrl = [].concat(ctrls)[0]

			scope.$watch 'codoshopVM.dropMenu.show', do (s = scope, ctrl, el) -> (newV, oldV) ->
				if newV == true and ctrl.mE
					console.log ctrl.mX, ctrl.mY
					console.log ctrl.mE.pageX, ctrl.mE.pageY

					el.css 'top', 0
					el.css 'left', 0
					el.position
						my: 'left top'
						of: ctrl.mE
						collision: 'fit'
				# else
				# 	el.css 'top', 0
				# 	el.css 'left', 0
				return

			# $( document ).mousemove do (s = scope, el, ctrl) -> (e) ->
			# 	# console.log ctrl.mX
			# 	if s.codoshopVM.dropMenu.show == true
			# 		# el.css 'top', e.pageY
			# 		# el.css 'left', e.pageX
			# 		el.position
			# 			my: 'left top'
			# 			of: e
			# 			collision: 'fit'
			# 	return

			$(document).click do (s = scope, el) -> () ->
				s.codoshopVM.dropMenu.show = false
				s.$apply()
				return

			return