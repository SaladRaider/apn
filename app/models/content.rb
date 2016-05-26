class Content < ActiveRecord::Base
	has_attached_file :media, :styles => { :small => "150x150>", :medium => "200x200>", :large => "250x250>" },
	:url  => "/assets/content/:id/:style/:basename.:extension",
	:path => ":rails_root/public/assets/content/:id/:style/:basename.:extension"

	validates_attachment_size :media, :less_than => 5.megabytes
	validates_attachment_content_type :media, :content_type => ['image/jpeg', 'image/png']
end