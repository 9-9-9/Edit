'use strict'

###*
 # @ngdoc function
 # @name Codoshop-Colors
 # @description
 # # Codoshop-Colors
 # Module for codoshop.
###
angular.module('codoshop-outline', [])
	.directive 'outline', () ->
		# require: '^codoshopp'
		link: (scope, el, attrs, ctrl) ->
			scope.treee = []

			scope.$watch () ->
				scope.selectedFile()
			, (newVal, oldVal, scope) -> do (cm = null, lines = [], folds = [], flatTree = []) ->

				scope.treee.length = 0
				if newVal
					cm = scope.cmLookup.get newVal
					cm.eachLine do (lines) -> (line) ->
						# console.log line
						lines.push line						
						return

					# console.log '______'
					lines.every do (scope, cm, folds) -> (v, i, a) -> do (fold = CodeMirror.fold.auto cm, {line: i, ch: 0}) ->
						folds.push fold if fold
						true


					lines.every do (scope, cm) -> (v, i, a) -> do (node = {}, fold = null, from = null, to = null, token = null) ->
						fold = CodeMirror.fold.auto cm, {line: i, ch: 0}
						if fold
							node.fold = fold
							# console.log fold
							to = fold.to
							from = fold.from
							if from.ch > 0
								# token = cm.getTokenAt {line: from.line, ch: from.ch - 1}
								# console.log token
								# if token.string == ' ' or token.string == ''
								# 	node.name = '(untitled)'
								# else
								# 	node.name = token.string
								node.name = cm.getRange
									line: from.line
									ch: 0
								,
									line: from.line
									ch: 9999999

						# for j in [0..v.text.length]
						# 	console.log cm.getTokenAt({line: i, ch: j})
						
						node.name = v.text
						node.nodes = []
						# scope.treee.push node

						true
					# console.log '______'
					# console.log scope.treee
					# for line, idx in lines			
						# line.text.split("").every do (line, idx, cm) -> (v, i, a) ->
						# 	console.log cm.getTokenAt({line: idx, ch: i})
						# 	true
						# asd = cm.getHelpers({line: idx, ch: 0})
						# console.log cm.getHelpers({line: idx, ch: 0}, 'fold')
						# asd = cm.getHelpers({line: idx, ch: 0}).fold.auto()
						# console.log asd
						# console.log CodeMirror.fold.auto(cm, {line: idx, ch: 0})

				return

			return