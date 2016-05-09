class Video < ActiveRecord::Base
	validates :title, presence: true, length: { minimum: 3 }
	validates :description, presence: true
	validates :link, presence: true
end
