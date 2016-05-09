class VideosController < ApplicationController
	before_action :find_params, only: [:show, :edit, :update, :destroy]

	def index
	end

	def new
		@video = Video.new
	end

	def create
		@video = Video.new(video_params)
		if @video.save
			redirect_to @video
		else
			render 'new'
		end
	end

	def show
	end

	def edit

	end

	def update
		if @video.update(params[:video].permit(:title, :show, :link, 
				:description, :keywords, :category))
			redirect_to @video
		else
			render 'edit'
		end
	end

	def find_params
		@video = Video.find(params[:id])
	end

	def destroy
		@video.destroy

		redirect_to root_path
	end

	private 
		def video_params
			params.require(:video).permit(:title, :show, :link, 
				:description, :keywords, :category);
		end
end