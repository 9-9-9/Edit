'use strict'

angular
	.module 'codoshop'
	.factory 'CodoshopFile', [() ->

		class CodoshopFile
			constructor: (@opts) ->
				@name 		= @opts.name
				@mode 		= @opts.mode
				@content 	= @opts.content
				@type = @opts.type
				# @selected 	= @opts.selected

		CodoshopFile
		]