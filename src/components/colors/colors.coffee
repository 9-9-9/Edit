'use strict'

###*
 # @ngdoc module
 # @name Codoshop-Colors
 # @description
 # # Codoshop-Colors
 # Module for codoshop.
###
angular.module('codoshop-colors', ['codoshop-parser'])
	.directive 'colorss', () ->
		# require: '^codoshopp'
		link: (scope, el, attrs, ctrl) ->

			# ctrl = [].concat(ctrl)[0]
			scope.colors = []

			scope.$watch () ->
				scope.selectedFile()

			, (newVal, oldVal, scope) -> do (cm = null) ->

				scope.colors.length = 0
				if newVal

					cm = scope.cmLookup.get newVal
					CodeMirror.runMode cm.getValue(), newVal.mode, (txt, style) -> do (c = null) ->
						# console.log txt + ' : ' + style
						if style == 'atom' or style == 'builtin'
							try
								c = chroma txt
								console.log c.css()
								scope.colors.push {'string': c.css()} if c
							catch e
								e = e
						return

				scope.fillers = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
					

					# console.log scope.colors
					

					# scope.colors.push {'c': c} for c in newVal.name.split("")

				return



			# ctrl.onSelect.then (r) ->

			# 	# r.file.weak.ctrl.cm
			# 	return
			return

