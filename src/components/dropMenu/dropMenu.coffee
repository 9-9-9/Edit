'use strict'

angular
	.module 'codoshopDropMenu', []
	.directive 'codoshopDropMenu', () ->
		controller: ($scope) -> do (dm = null) ->

			$scope.codoshopVM.dropMenu ?= {}
			dm = $scope.codoshopVM.dropMenu

			dm.show ?= false
			dm.anchor ?= null

			return
		link: (scope, el, attrs, ctrls) ->

			scope.$watch 'codoshopVM.dropMenu.anchor', do (s = scope) -> (newV, oldV) ->
				if newV
					el.position
						my: 'left top'
						at: 'right top'
						of: newV
					s.apply()
				return

			return