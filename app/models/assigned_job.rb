class AssignedJob < ActiveRecord::Base
	belongs_to :video
	has_one :user
end
