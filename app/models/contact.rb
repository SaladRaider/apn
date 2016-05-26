class Contact < ActiveRecord::Base
	validates :full_name, presence: true
	validates :subject, presence: true
	validates :message, presence: true
	validates :email, presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }
end
