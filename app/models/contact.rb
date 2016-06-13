class Contact < ActiveRecord::Base
	validates :org_club, presence: true
	validates :sub_date, presence: true
	validates :full_name, presence: true
	validates :id_number, presence: true, length: { is: 5 }
	validates :email, presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }
	validates :subject, presence: true
	validates :message, presence: true
end
