---
---
class window.App
	postlist: undefined

	constructor: () ->

	init: () ->
		app.postlist = new Postlist
		app.postlist.init()
	
class window.Postlist
	options: {
		dataid: "[data-reveal]"
	}

	doc: $(document)
	win: $(window)
	queue: undefined
	
	constructor: () ->

	init: () ->
		app.postlist.queue = $(@options.dataid)
		
		if Modernizr.touch
			app.postlist.queue = []
		else
			app.postlist.doc.scroll(app.postlist.handler)
			app.postlist.win.resize(app.postlist.handler)
			
	handler: () ->
		if app.postlist.queue isnt undefined
			visibile_el = $.grep(app.postlist.queue, (el, i) ->
				try
					st = app.postlist.win.scrollTop()
					h = app.postlist.win.height()
					top = $(el).offset().top
					if st + h > top
						console.log("ASDF")
			)
			
$ ->
	window.app = new App
	app.init()