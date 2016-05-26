class Content < ActiveRecord::Base
	has_attached_file :media,
	:url  => "/assets/content/:id/:style/:basename.:extension",
	:path => ":rails_root/public/assets/content/:id/:style/:basename.:extension"

	validates :title, presence: true
	validates_attachment_content_type :media, :content_type => ['image/jpeg', 'image/png', 'video/mp4', 'video/webm']
end