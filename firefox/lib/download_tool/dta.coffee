
main_window = require('sdk/window/utils').getMostRecentBrowserWindow()

DTA = main_window.DTA
#{Cu} = require 'chrome'
#glue = {}
#Cu.import("chrome://dta-modules/content/glue.jsm", glue)
#DTA = glue.require("api")

download_tasks = (tasks) ->
	referer = 'http://dynamic.cloud.vip.xunlei.com/'

	links = []

	for t in tasks
		if t.status_text != 'completed'
			continue
		links.push
			url: new DTA.URL DTA.IOService.newURI t.download_url, 'utf-8', null
			referrer: referer
			fileName: t.filename
			description: t.name
			ultDescription: t.name

#	console.log links
	DTA.saveLinkArray main_window, links, []

download_tasks_to_dir = (tasks, dirname) ->
	referer = 'http://dynamic.cloud.vip.xunlei.com/'
	numIstance = DTA.incrementSeries()
	mask = DTA.getDropDownValue 'renaming', false

	join_path = require('sdk/io/file').join

	links = []

	for t in tasks
		if t.status_text != 'completed'
			continue
		dir = if t.dirs?.length then join_path.call(null, dirname, t.dirs...) else dirname
		links.push
			url: new DTA.URL DTA.IOService.newURI t.download_url, 'utf-8', null
			referrer: referer
			fileName: t.filename
			dirSave: dir
			description: t.name
			ultDescription: t.name
			numIstance: numIstance
			mask: mask

#	console.log links
#	DTA.turboSendLinksToManager main_window, links
	DTA.sendLinksToManager main_window, true, links


if DTA?
	module.exports =
		download_tasks: download_tasks
		download_tasks_to_dir: download_tasks_to_dir
else
	module.exports = undefined
