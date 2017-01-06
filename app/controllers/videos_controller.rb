require 'uri'

class VideosController < ApplicationController
	before_action :find_params, only: [:show, :edit, :update, :destroy]
	before_action :authenticate_user!, except: [:index, :show]
	before_action :find_user, only: [:create]
	before_action :find_users_this_year, only: [:new, :edit, :create, :update]
	before_action :find_assigned_jobs, only: [:edit]
	load_and_authorize_resource

	def index

		#get search time
		@min_year = Video.minimum("created_at")
		@max_year = Video.maximum("created_at")
		@esc = (Rails.env == "production") ? "\"" : "`"
		@category_is_set = !params[:category].nil?

		start_year = @min_year
		end_year = @max_year

		default_vid_limit = 6
		vid_offset = params[:num_loaded] != nil ? params[:num_loaded] : 0

		if params[:year] != nil && params[:year] != "-1"
			start_year = Time.new(params[:year].to_i, 8)
			end_year = Time.new(params[:year].to_i + 1, 8)
		end

		select_str = "#{@esc}videos#{@esc}.*";

		if params[:search_str] != nil && !params[:search_str].empty?
			select_str += ", ("
			str_ar = params[:search_str].split(' ')
			str_ar.each_with_index do |str, index|
				#str = ActiveRecord::Base.connection.quote(str)
				select_str += "(
				CASE
				WHEN UPPER(videos.title) LIKE '%"+str.upcase+"%' THEN 3
				ElSE 0 END
				) + (
				CASE
				WHEN UPPER(#{@esc}videos#{@esc}.description) LIKE '%"+str.upcase+"%' THEN 2
				ElSE 0 END
				) + (
				CASE
				WHEN UPPER(#{@esc}videos#{@esc}.keywords) LIKE '%"+str.upcase+"%' THEN 1
				ElSE 0 END
				)";
				if index != str_ar.length - 1
					select_str += "+"
				end
			end
			select_str += "+ (
			CASE
			WHEN UPPER(#{@esc}videos#{@esc}.title) LIKE '%"+params[:search_str].upcase+"%' THEN 9
			ElSE 0 END
			) + (
			CASE
			WHEN UPPER(#{@esc}videos#{@esc}.description) LIKE '%"+params[:search_str].upcase+"%' THEN 6
			ElSE 0 END
			) + (
			CASE
			WHEN UPPER(#{@esc}videos#{@esc}.keywords) LIKE '%"+params[:search_str].upcase+"%' THEN 3
			ElSE 0 END
			)";
			select_str += ") AS score"
		else
			select_str = "#{@esc}videos#{@esc}.*, CASE WHEN 1=1 THEN 0 ELSE 0 END AS score"
		end

		user_id = (params[:user_id] != nil) ? params[:user_id] : -1

		@videos = Video.select(select_str)
		.where.not(link: nil)
		.where('length(link) > 0')
		.where('link LIKE \'%youtu%\'')
		.where("(#{@esc}user_id#{@esc} = ? OR -1 = ?) AND (#{@esc}category#{@esc} = ? OR ?) AND (#{@esc}show#{@esc} = ? OR ?)",
			user_id,
			user_id,
			params[:category],
			(params[:category] == nil || params[:category] == "-1"),
			params[:show_num],
			(params[:show_num] == nil || params[:show_num] == "-1")
			).where(created_at: start_year..end_year)
		.order('score DESC')

		if params[:sort_method] != '2'
			@videos = @videos.order(created_at: :desc)
		else
			@videos = @videos.order(views: :desc)
		end

		max_rows = @videos.count(:id)
		@videos = @videos.limit(default_vid_limit).offset(vid_offset)
		@shows = Video.where.not(show: nil).order(show: :asc).uniq.pluck(:show)
		respond_to do |format|
			format.html
			format.json { render :json => { videos: @videos, max_rows: max_rows, select_str: select_str } }
		end
	end

	def pending
		@videos = Video.paginate(:page => params[:page], :per_page => 10)
		.where("link = NULL OR length(link) <= 0 OR link NOT LIKE '%youtub%'")
	end

	def new
		@video = Video.new
		@assigned_jobs = []
	end

	def create
		@assigned_jobs = params[:assigned_jobs]

		if current_user.get_current_grade == "Alumni" and current_user.role != "admin"
			@video.errors.add(:base, 'Alumni may not create new videos.')
			render 'new' and return
		end

		if params[:video][:link].length > 0 && !valid_youtube_url?(params[:video][:link])
			@video.errors.add(:base, 'Please enter a valid YouTube link. (Copy and paste the video link from the address bar on YouTube)')
			render 'new' and return
		end

		@video = @user.videos.new(video_params)
		jobs = params[:assigned_jobs]
		saving_jobs = params[:assigned_jobs] != nil

		if saving_jobs
			params[:assigned_jobs].each_with_index do |job, index|
				user = @users.select(:id).where(first_name: job["full_name"].split(' ')[0], last_name: job["full_name"].split(' ')[1]).first

				if user == nil
					@video.errors.add(:base, 'The person added to a job was not found in the APN database for this year.')
					render 'new' and return
				end

				params[:assigned_jobs][index][:user_id] = user.id
				params[:assigned_jobs][index][:video_id] = @video.id
				params[:assigned_jobs][index] = params[:assigned_jobs][index].except("full_name")
			end

			@assigned_jobs = params[:assigned_jobs].collect { |job| @video.assigned_jobs.new(job_descriptoin: job[:job_description], user_id: job[:user_id], video_id: job[:video_id]) }
		end

		if @video.save
			if saving_jobs
				if @assigned_jobs.all?(&:valid?)
					@assigned_jobs.each(&:save!)
					if @video.link.length > 0
						redirect_to @video
					else
						redirect_to '/pending_videos'
					end
				else
					@video.destroy
					render 'new'
				end
			else
				if @video.link.length > 0
					redirect_to @video
				else
					redirect_to '/pending_videos'
				end
			end
		else
			render 'new'
		end
	end

	def show
		@assigned_jobs = AssignedJob.select(:user_id,:job_descriptoin).where(video_id: @video.id)
		@full_names = []
		@users = []

		@video.update_column :views, @video.views+1

		if @assigned_jobs != nil
			@assigned_jobs.each do |job|
				user = User.find(job.user_id)
				@full_names << (user.first_name + " " + user.last_name)
				@users << user
			end
		end
	end

	def edit
	end

	def update
		@assigned_jobs = params[:assigned_jobs]
		if current_user.get_current_grade == "Alumni" and current_user.role != "admin"
			@video.errors.add(:base, 'Alumni may not edit new videos.')
			render 'edit' and return
		end

		if params[:video][:link].length > 0 && !valid_youtube_url?(params[:video_link])
			@video.errors.add(:base, 'Please enter a valid YouTube link. (Copy and paste the video link from the address bar on YouTube)')
			render 'edit' and return
		end

		if @video.update(video_params)
			if params[:assigned_jobs] != nil
				# update the assigned_jobs
				params[:assigned_jobs].each_with_index do |job, index|
					user = @users.select(:id).where(first_name: job["full_name"].split(' ')[0], last_name: job["full_name"].split(' ')[1]).first

					if user == nil
						@video.errors.add(:base, 'The person added to a job was not found in the APN database for this year.')
						render 'new' and return
					end

					params[:assigned_jobs][index][:user_id] = user.id
					params[:assigned_jobs][index][:video_id] = @video.id
					params[:assigned_jobs][index] = params[:assigned_jobs][index].except("full_name")
				end

				@existing_jobs = AssignedJob.select(:id, :user_id, :job_descriptoin).where(video_id: @video.id).joins("LEFT OUTER JOIN users ON users.id = assigned_jobs.user_id")
				user_ids = []

				params[:assigned_jobs].each do |job|
					clone_job = @existing_jobs.where(user_id: job[:user_id])
					user_ids <<  job[:user_id]

					if clone_job.empty?
						@video.assigned_jobs.new(job_descriptoin: job[:job_description], user_id: job[:user_id], video_id: job[:video_id]).save!
					elsif job[:job_description] != clone_job.first.job_descriptoin
						clone_job.first.update(job_descriptoin: job[:job_description])
					end
				end

				@existing_jobs.where.not(user_id: user_ids).each do |job|
					job.destroy!
				end
			else
				@existing_jobs = AssignedJob.destroy_all(:video_id => @video.id)
			end

			if @video.link.length > 0
				redirect_to @video
			else
				redirect_to '/pending_videos'
			end
		else
			#redirect_to edit_video_path(@video)
			@assigned_jobs = params[:assigned_jobs];
			render 'edit'
		end
	end

	def find_params
		@video = Video.friendly.find(params[:id])
	end

	def find_user
		@user = current_user
	end

	def find_users_this_year
		# figure out what school year it is. New year starts on August 1
		now = DateTime.now
		august_date = (now > DateTime.new(now.year, 8, 1)) ? DateTime.new(now.year - 3, 8, 1) : DateTime.new(now.year - 4, 8, 1)
		@users = User.select(:first_name, :last_name, :id
		).where(created_at: august_date..now).where(
		"ABS(FLOOR(DATEDIFF(
					created_at,
					'" + august_date.change(year: august_date.year + 3).to_s + "'
				) / 365)) + grade <= 12")
	end

	def find_assigned_jobs
		@assigned_jobs = AssignedJob.select(:id, :user_id, :job_descriptoin, :last_name, :first_name).where(video_id: @video.id).joins("LEFT OUTER JOIN users ON users.id = assigned_jobs.user_id")#User.select(:id,:last_name,:first_name).joins(:assigned_jobs).joins(:videos)#
	end

	def destroy
		@video.destroy

		redirect_to root_path
	end


	def valid_youtube_url?(uri)
	  !uri.nil? && uri.index("v=") && uri =~ /\A#{URI::regexp}\z/
	end

	private
	def video_params
		params.require(:video).permit(:title, :show, :link, :description, :keywords, :category, :slug, :user_id, :bite, :computer, :duration)
	end

	def assigned_job_params
		params.require(:assigned_jobs).permit(:job_descriptoin, :user_id, :video_id)
	end
end
