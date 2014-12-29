'use strict'

angular.module('codoshopTextEditor', [])
	.directive 'codoshopTextEditorInstance', () ->
		controller: ($scope) -> do (vm = null) =>

			# vm = $scope.codoshopVM
			# vm.codeMirror ?= {}
			# vm.codeMirror.refresh ?= 0

			return
		link: (scope, el, attrs, ctrls) -> do (el = $(el), vm = scope.codoshopVM, mode = scope.file.mode, reader = null, myCM = null) ->

			# ctrl = [].concat(ctrl)[0]
			# scope.file.content
			

			scope.opts =
				value		: scope.file.content
				mode 		: mode
				lineNumbers : true
				foldGutter 	: true
				gutters		: ['CodeMirror-linenumbers', 'CodeMirror-foldgutter']
				theme		: 'night'

			# vm.codeMirror.refresh += 1

			myCM = CodeMirror el[0],
				scope.opts

			scope.cmLookup.set scope.file, myCM 


			myCM.setSize el.width(), el.height()

			# TODO: Performance
			scope.$watchGroup ['codoshopVM.w', 'codoshopVM.h'], do (el) -> (newVs, oldVs) -> do (w = null, h = null) ->
				w = el.width()
				h = el.height()
				if w != 0 and h != 0
					myCM.setSize w, h
				return
			# scope.$watch do (el) -> () ->

			# 	return
			# ,
			# (n, o) ->

			# 	return
			return
