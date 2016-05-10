class Video < ActiveRecord::Base
	extend FriendlyId
	validates :title, presence: true, length: { minimum: 3 }
	validates :description, presence: true
	validates :link, presence: true
	belongs_to :user
	friendly_id :title, use: :slugged
end
