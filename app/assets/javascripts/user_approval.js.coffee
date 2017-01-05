
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/



$ ->
	ajax_approval = (conf,id) ->
		console.log("ran function")
		$.ajax({
			type: "POST"
			url: '/users/' + id
			data: {
				"_method":"put"
				approving: true
				user:
					admin_confirmed: conf
			}
			success:
				(data) ->
					$("#user-row-"+data.user_id).remove();
			error:
				(data) ->
					$("#user-row-"+data.user_id).append('error');

			dataType: 'json'
		})

	$('.a-btn').on 'click', ->
		console.log "clicked a btn; id: " + $(this).attr("value")
		ajax_approval('1',$(this).attr("value"))

	$('.d-btn').on 'click', ->
		console.log "clicked d btn; id: " + $(this).attr("value")
		ajax_approval('-1',$(this).attr("value"))
