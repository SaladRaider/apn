class VideosController < ApplicationController
	def index
	end

	def new
	end

	def create
		@video = Video.new(video_params)
		@video.save

		redirect_to @video
	end

	def show
		@video = Video.find(params[:id])
	end

	private 
		def video_params
			params.require(:video).permit(:title, :show, :link, 
				:description, :keywords, :category);
		end
end
