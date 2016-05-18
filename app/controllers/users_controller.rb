class UsersController < ApplicationController
	before_action :find_user, only: [:show, :edit, :update]

	def index
	end

	def show
		# find user videos
		@videos = Video.where("(`user_id` = ?) AND(`category` = ? OR ?) AND (`show` = ? OR ?)", 
			@user.id,
			params[:category], 
			(params[:category] == nil || params[:category] == "-1"),
			params[:show_num], 
			(params[:show_num] == nil || params[:show_num] == "-1")
			)
			.order(created_at: :desc)
		@videos = @videos.limit(6)
		@shows = Video.where.not(show: nil).order(show: :asc).uniq.pluck(:show)
		@min_year = Video.minimum("created_at")
		@max_year = Video.maximum("created_at")
	end

	def edit
	end

	def update
		if @user.update(params[:user].permit(:last_name, :first_name, :id_number, :grade, :email, :bio))
			redirect_to @user
		else
			render 'edit'
		end
	end

	private
		def find_user
			@user = User.friendly.find(params[:id])
		end
end
