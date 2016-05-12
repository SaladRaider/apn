$("#add_job").click(function () {
	if($("#user_name_search").val().length <= 0 || $("#job_description").val().length <= 0)  {
		$("#job_error").html('You cannot have empty fields');
		return;
	}

	if($.inArray($("#user_name_search").val(), availableUsers) == -1) {
		$("#job_error").html('"'+$("#user_name_search").val()+'" does not exist in the APN user database for this year.');
		return;
	}

	var user_name = $("#user_name_search").val().replace(/\s+/g, '-').toLowerCase();

	if($("#user-"+user_name).length) {
		$("#job_error").html('"'+$("#user_name_search").val()+'" is already added to the job list.');
		return;
	}

	var list = document.getElementById("list_of_jobs");

	list.insertAdjacentHTML('beforeend', '<span id="user-' + user_name + '"><div class="col-xs-4"><p>' + $("#user_name_search").val() + '</p></div><div class="col-xs-7"><p>' + $("#job_description").val() + '</p></div><div class="col-xs-1"><p><a onclick="$(\'#user-'+user_name+'\').remove();" id="delete-'+user_name+'">Delete</a></p></div><input type="hidden" name="assigned_jobs[][full_name]" value="'+$("#user_name_search").val()+'" /><input type="hidden" name=assigned_jobs[][job_description] value="'+$("#job_description").val()+'" /></span>');
	$("#user_name_search").val("");
	$("#job_description").val("");
	$("#job_error").html('');
});