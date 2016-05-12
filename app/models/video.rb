class Video < ActiveRecord::Base
	extend FriendlyId

	belongs_to :user
	has_many :assigned_jobs, dependent: :destroy
	accepts_nested_attributes_for :assigned_jobs

	validates :title, presence: true, length: { minimum: 3 }
	validates :description, presence: true
	validates :link, presence: true
	validates :show, presence: true
	friendly_id :title, use: :slugged
end
