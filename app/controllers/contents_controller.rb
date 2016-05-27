class ContentsController < ApplicationController
	before_action :authenticate_user!
	before_action :find_content, only: [:edit, :update]
	load_and_authorize_resource

	def index
		@contents = Content.all
	end

	def new
		@content = Content.new
	end

	def create
		@content = Content.new(content_params)

		if @content.save
			redirect_to contents_path
		else
			render 'new'
		end
	end

	def edit
	end

	def update
		if @content.update(content_params)
			redirect_to contents_path
		else
			render 'edit'
		end
	end

	private 
		def content_params
			params.require(:content).permit(:title, :text, :media);
		end

		def find_content
			@content = Content.find(params[:id])
		end
end
