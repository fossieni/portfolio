---
---
class window.App
	doc: $(document)
	win: $(window)

	postlist: undefined
	isIE10: false
	isIE11: false
	isEDGE: false

	constructor: () ->

	init: () ->
		ie10 = navigator.userAgent.match(/MSIE\s?(\d+)(?:\.(\d+))?/i)
		if ie10 isnt undefined and ie10 isnt null and ie10[1] is "10"
			@isIE10 = true
			document.documentElement.className += " ie10"
	
		ie11 = navigator.userAgent.match(/Trident.*?rv:11/i)
		if ie11 isnt undefined and ie11 isnt null
			@isIE11 = true
			document.documentElement.className += " ie11"

		edge = navigator.userAgent.match(/Edge/i)
		if edge isnt undefined and edge isnt null
			@isEDGE = true
			document.documentElement.className += " msedge"
	
		app.objectfit = new MSObjectFit
		app.postlist = new Postlist
		app.objectfit.init()
		app.postlist.init()

class window.History


class window.MSObjectFit
	options: {
		objectfit_selector: ".gallery img"	
	}
	
	constructor: () ->
	
	init: () ->
		if app.isIE10 or app.isIE11 or app.isEDGE
			this.process(el) for el in $(@options.objectfit_selector)
			
	process: (el) ->
		el_width = $(el).width()
		el_height = $(el).height()
		el_aspect = el_width / el_height
		parent_width = $(el.parentNode).width()
		parent_height = $(el.parentNode).height()
		parent_aspect =  parent_width / parent_height
		if el_aspect > parent_aspect
			$(el).addClass("ms-wider")
		else
			$(el).addClass("ms-taller")
	
class window.Postlist
	options: {
		position_queue_selector: "[data-reveal-position]"
	}

	position_queue: undefined
	
	constructor: () ->

	init: () ->
		app.postlist.position_queue = $(@options.position_queue_selector)	
		
		for el in app.postlist.position_queue
			el.trig_id = $(el).data("reveal-position")
			el.trig_in = $("[data-reveal-in-id='#{el.trig_id}']")
			el.trig_out = $("[data-reveal-out-id='#{el.trig_id}']")
			
		app.doc.scroll(app.postlist.handler)
		app.win.resize(app.postlist.handler)
		app.postlist.handler()
			
	handler: () ->
# 		app.win.requestAnimationFrame(handler)
		w = app.win.innerWidth()
		if app.postlist.position_queue isnt undefined and w > 992
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
