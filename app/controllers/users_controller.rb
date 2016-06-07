class UsersController < ApplicationController
	before_action :authenticate_user!, except: [:index, :show]
	before_action :find_user, only: [:show, :edit, :update]
	load_and_authorize_resource

	def index
		@users = User.all
	end

	def show
		# find user videos
		
		@esc = (Rails.env == "production") ? "\"" : "`"

		@videos = Video.where("(user_id = ?) AND(category = ? OR ?) AND (#{@esc}show#{@esc} = ? OR ?)", 
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
		updated = @user.update(user_params)

		respond_to do |format|
			if !params[:approving]
				if updated
					format.html
					redirect_to @user and return
				else
					format.html
					render 'edit' and return
				end
			else
				format.json { render :json => { user_id: @user.id } }
			end
		end
	end

	private
		def find_user
			@user = User.friendly.find(params[:id])
		end

		def user_params
			params.require(:user).permit(:last_name, :first_name, :id_number, :grade, :email, :bio, :avatar, :admin_confirmed)
		end
end
