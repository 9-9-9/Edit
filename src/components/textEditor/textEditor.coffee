'use strict'

angular.module('codoshopTextEditor', [])
	.directive 'codoshopTextEditorInstance', () ->
		controller: ($scope) -> do (vm = null) =>

			# vm = $scope.codoshopVM
			# vm.codeMirror ?= {}
			# vm.codeMirror.refresh ?= 0

			return
		link: (scope, el, attrs, ctrls) -> do (el = $(el), s = scope, vm = scope.codoshopVM, mode = scope.file.mode, reader = null, myCM = null) ->

			# ctrl = [].concat(ctrl)[0]
			# scope.file.content
			

			s.opts =
				value		: s.file.content ? ''
				mode 		: mode ? 'plaintext'
				lineNumbers : true
				foldGutter 	: true
				gutters		: ['CodeMirror-linenumbers', 'CodeMirror-foldgutter']
				theme		: 'night'
				autofocus	: true

			# vm.codeMirror.refresh += 1

			myCM = CodeMirror el[0],
				s.opts

			s.cmLookup.set s.file, myCM 

			myCM.setSize '100%', '100%'
			# myCM.on 'focus', do (el, myCM) -> () -> do (w = el.width(), h = el.height()) ->
			# 	console.log 'focused'
			# 	if w != 0 and h != 0
			# 		myCM.setSize el.width(), el.height()
			# 	return
			

			# TODO: Performance
			# s.$watchGroup ['codoshopVM.w', 'codoshopVM.h'], do (el) -> (newVs, oldVs) -> do (w = null, h = null) ->
			# 	w = el.width()
			# 	h = el.height()
			# 	if w != 0 and h != 0
			# 		myCM.setSize w, h
			# 	return

			# scope.$watch do (el) -> () ->
			# 	# console.log el.width() + el.height()
			# 	el.width() + el.height()
			# ,
			# do (el, myCM) -> (n, o) -> do (w = el.width(), h = el.height()) ->
			# 	# TODO: Why does height and width report 0?
			# 	if el.css('display') != 'none' and w != 0 and h != 0
			# 		console.log w + ' ' + h
			# 		console.log 'size adjusted'
			# 		myCM.setSize w, h
			# 	return
			return
