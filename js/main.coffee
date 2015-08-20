---
---
class window.App
	doc: $(document)
	win: $(window)

	postlist: undefined

	constructor: () ->

	init: () ->
		app.postlist = new Postlist
		app.postlist.init()
	
class window.Postlist
	options: {
		position_queue_selector: "[data-reveal-position]"
	}

	position_queue: undefined
	
	constructor: () ->

	init: () ->
		app.postlist.position_queue = $(@options.position_queue_selector)	
		
		if Modernizr.touch
			app.postlist.position_queue = []
		else
			for el in app.postlist.position_queue
				el.trig_id = $(el).data("reveal-position")
				el.trig_in = $("[data-reveal-in-id='#{el.trig_id}']")
				el.trig_out = $("[data-reveal-out-id='#{el.trig_id}']")
				
			app.doc.scroll(app.postlist.handler)
			app.win.resize(app.postlist.handler)
			app.postlist.handler()
			
	handler: () ->
# 		app.win.requestAnimationFrame(handler)
		if app.postlist.position_queue isnt undefined
			visibile_el = $.grep(app.postlist.position_queue, (el, i) ->
				try
					st = app.win.scrollTop()
					h = app.win.height()
					if ((el.trig_in.length == 1 and el.trig_out.length == 1 and st + h/2 > $(el.trig_in).offset().top and st + h/2 < $(el.trig_out).offset().top) or (el.trig_in.length == 1 and el.trig_out.length == 0 and st + h/2 > $(el.trig_in).offset().top))
						$(el).addClass("active")
					else
						$(el).removeClass("active")			
			)
			
$ ->
	window.app = new App
	app.init()