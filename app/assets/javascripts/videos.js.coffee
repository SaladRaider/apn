# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ -> 
	loading = false
	max_rows = -1

	ajax_videos = (num_loaded) ->
		video_box = $("#search-videos")
		console.log("num_loaded is " + num_loaded)
		$.ajax({
			type: "GET"
			url: '/videos'
			data: {
				category: $("#category").val()
				show_num: $('#show-num').val()
				year: $('#year').val()
				sort_method: $("#sort-method").val()
				search_str: $("#search-str").val()
				num_loaded: num_loaded
			}
			success: 
				(data) ->
					console.log('successful ajax request: ' + JSON.stringify(data))
					max_rows = data['max_rows']
					arrayLength = data['videos'].length
					for i in [0...arrayLength]
						video_link = data['videos'][i]['link']
						start_pos = video_link.indexOf("v=")+2

						end_pos = if video_link.indexOf("&", start_pos) != -1 then video_link.indexOf("&", start_pos) else video_link.length
						video_id = video_link.substring(start_pos, end_pos)
						
						# check if max res thumbnail exists. If not, use hq default
						url = 'http://img.youtube.com/vi/'+video_id+'/hqdefault.jpg'

						title_length = 30
						video_title = if data['videos'][i]['title'].length > title_length then (data['videos'][i]['title'].substring(0, title_length) + "...") else data['videos'][i]['title']

						video_box.append("
						<a href='/videos/"+data['videos'][i]['slug']+"'>
						<div id='vid-"+data['videos'][i]['slug']+"' class=\"col-md-6 col-sm-6 col-xs-12 watch-block wow flipInX\" style=\"background-image: url("+url+")\">
						  <div class=\"block-filler\">
						    <div class=\"abs-centered-element\">
						     <h4 class=\"block-header-text\">"+video_title+"</h4>
						     <i class=\"fa fa-play\"></i>
						   </div>
						 </div>
						</div>
						</a>")
					loading = false
			error:
				(data) ->
					console.log('there seems to be an error with AJAX JSON request: ' + JSON.stringify(data))
					video_box.html(('<p>'+JSON.stringify(data)+'</p>').replace(/\\n/g, '<br>'))
					arrayLength = data["responseText"].length
					video_box.html('')
					for i in [1..0]
						video_box.append(data["responseText"] + ",")
					loading = false
			dataType: 'json'
		})

	search_for_videos = (event) ->
		event.preventDefault()
		console.log('clicked btn')
		$("#search-videos").html('')
		ajax_videos(0)

	load_more_videos = ->
		loading = true
		console.log("loading more videos...")
		ajax_videos($("#search-videos a").length)

	$('#search-btn').on 'click', search_for_videos

	$("#search-str").keypress((e) ->

		keycode = if e.keyCode then e.keyCode else e.which
		console.log('pressed key: '+keycode)
		if keycode == 13
			console.log('pressed enter key')
			search_for_videos e
	)

	$('select').change search_for_videos

	$(window).scroll -> 
		if !loading && (max_rows == -1 || $("#search-videos a").length < max_rows) && $(window).scrollTop() > $(document).height() - $(window).height() - 60
			load_more_videos()
