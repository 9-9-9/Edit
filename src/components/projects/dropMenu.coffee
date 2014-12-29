'use strict'

angular
	.module 'codoshopDropMenu'
	# .config ($stateProvider, $urlRouterProvider) ->

	# 	$stateProvider.state 'projectsDropMenu',
	# 		views:
	# 			dropMenu:
	# 				templateUrl: 'components/projects/dropMenu.html'

	# 	return
	.directive 'codoshopProjectsDropMenu', () ->
		# templateUrl: 'components/projects/dropMenu.html'
		link: (scope, el, attrs, ctrls) -> do (fi = null) ->

			fi =$(el).find('input')

			fi[0].addEventListener 'change', (e) -> do (file = null, textType = null, fr = null) ->
				file = fi.files[0]
				textType = /text.*/

				if file.type.match(textType)
					fr = new FileReader()
					fr.onload = (e) ->
						# fileDisplayArea.innerText = reader.result
						return
					fr.readAsText file
				return

			scope.inputFile = do (s = scope, fi) -> (e) ->
				e.stopPropagation()
				fi.show()
				fi.click()
				fi.hide()
				return

			scope.rename = () ->

				return

			scope.reveal = () ->

				return

			scope.remove = () ->

				return

			return