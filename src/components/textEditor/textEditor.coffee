'use strict'

angular.module('codoshopTextEditor', [])
	.directive 'codoshopTextEditor', () ->
		link: (scope, el, attrs, ctrls) -> do (mode = scope.file.mode) ->
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
