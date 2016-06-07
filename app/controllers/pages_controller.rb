class PagesController < ApplicationController
	include HighVoltage::StaticPage

	layout :layout_for_page

	private

	def layout_for_page
		case params[:id]
		when 'home'
			'home'
		when 'user_approval'
			authorize! :user_approval, current_user
			'application'
		else
			'application'
		end
	end
end
