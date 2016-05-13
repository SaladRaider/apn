class VideosController < ApplicationController
	before_action :find_params, only: [:show, :edit, :update, :destroy]
	before_action :authenticate_user!, except: [:index, :show]
	before_action :find_user, only: [:create]
	before_action :find_users_this_year, only: [:new, :edit, :create, :update]
	before_action :find_assigned_jobs, only: [:new, :edit]
	#load_and_authorize_resource

	def index
		@videos = Video.all.order('created_at DESC')
	end

	def new
		@video = Video.new
	end

	def create
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
					redirect_to @video
				else
					@video.destroy
					render 'new'
				end
			else
				redirect_to @video
			end
		else
			render 'new'
		end
	end

	def show
		@assigned_jobs = AssignedJob.select(:user_id,:job_descriptoin).where(video_id: @video.id)
		@full_names = []

		if @assigned_jobs != nil
			@assigned_jobs.each do |job|
				user = User.find(job.user_id)
				@full_names << (user.first_name + " " + user.last_name)
			end
		end
	end

	def edit

	end

	def update
		if @video.update(params[:video].permit(:title, :show, :link, :description, :keywords, :category))
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
			redirect_to @video
		else
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
		august_date = (now > DateTime.new(now.year, 8, 1)) ? DateTime.new(now.year, 8, 1) : DateTime.new(now.year - 1, 8, 1)
		@users = User.select(:id, :first_name, :last_name).where(created_at: august_date..now)
	end

	def find_assigned_jobs
		@assigned_jobs = AssignedJob.select(:id, :user_id, :job_descriptoin, :last_name, :first_name).where(video_id: @video.id).joins("LEFT OUTER JOIN users ON users.id = assigned_jobs.user_id")#User.select(:id,:last_name,:first_name).joins(:assigned_jobs).joins(:videos)#
	end

	def destroy
		@video.destroy

		redirect_to root_path
	end

	private 
	def video_params
		params.require(:video).permit(:title, :show, :link, 
			:description, :keywords, :category, :slug, :user_id);
	end

	def assigned_job_params
		params.require(:assigned_jobs).permit(:job_descriptoin, :user_id, :video_id)
	end
end
