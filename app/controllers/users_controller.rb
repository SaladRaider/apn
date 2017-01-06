class UsersController < ApplicationController
	before_action :authenticate_user!, except: [:index, :show]
	before_action :find_user, only: [:show, :edit, :update]
	before_action :find_users_this_year, only: [:index]
	before_action :find_alumni_by_years, only: [:index]
	load_and_authorize_resource

	def index
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
		.where.not(link: nil)
		.where('length(link) > 0')
		.where('link LIKE \'%youtu%\'')
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

		def find_users_this_year
			# figure out what school year it is. New year starts on August 1
			now = DateTime.now
			august_date = (now > DateTime.new(now.year, 8, 1)) ? DateTime.new(now.year - 3, 8, 1) : DateTime.new(now.year - 4, 8, 1)
			if Rails.env.production?
				@current_users = User.where(created_at: august_date..now).where("
					ABS(FLOOR((DATE_PART('day',CAST(created_at AS date)) - DATE_PART('day','" + august_date.change(year: august_date.year + 2).to_s + "'::date)) / 365))
					+ grade <= 12
					")
			else
				@current_users = User.where(created_at: august_date..now).where(
				"ABS(FLOOR(DATEDIFF(
							created_at,
							'" + august_date.change(year: august_date.year + 3).to_s + "'
						) / 365)) + grade <= 12").where(admin_confirmed: 1)
			end
		end

		def find_alumni_by_years

			now = DateTime.now
			present_august_date = (now > DateTime.new(now.year, 8, 1)) ? DateTime.new(now.year, 8, 1) : DateTime.new(now.year - 1, 8, 1)
			august_date = present_august_date.clone()
			old_august_date = DateTime.new(august_date.year - 1, august_date.month, august_date.day)
			@alumni = []
			@years = []
			loop do
				if Rails.env.production?
					user = User.where(created_at: old_august_date..august_date).where("
						ABS(FLOOR((DATE_PART('day',CAST(created_at AS date)) - DATE_PART('day','" + present_august_date.change(year: present_august_date.year - 1).to_s + "'::date)) / 365))
						+ grade > 12
						")
				else
					user = User.where(created_at: old_august_date..august_date).where(
					"ABS(FLOOR(DATEDIFF(
								created_at,
								'" + present_august_date.to_s + "'
							) / 365)) + grade > 12").where(admin_confirmed: 1)
				end
				@alumni << user
				@years << old_august_date.year.to_s + "-" + august_date.year.to_s
				august_date = old_august_date.clone()
				old_august_date = old_august_date.change(year: old_august_date.year-1)
				break if @alumni.last.empty?
			end
			@alumni = @alumni[0..-2]
		end
end
