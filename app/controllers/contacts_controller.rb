class ContactsController < ApplicationController
	def new
		@contact = Contact.new
	end

	def create
		@contact = Contact.new(contact_params)
		
		if @contact.save
			redirect_to '/thanks'
		else
			render 'new'
		end
	end

	private
		def contact_params
			params.require(:contact).permit(:org_club,:sub_date,:full_name,:id_number,:email,:subject,:message)
		end
end
