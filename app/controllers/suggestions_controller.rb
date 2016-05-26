class SuggestionsController < ApplicationController
	def new
		@suggestion = Suggestion.new
	end

	def create
		@suggestion = Suggestion.new(suggestion_params)

		if @suggestion.save
			redirect_to '/thanks'
		else
			render 'new'
		end
	end

	private
		def suggestion_params
			params.require(:suggestion).permit(:subject,:message)
		end
end
