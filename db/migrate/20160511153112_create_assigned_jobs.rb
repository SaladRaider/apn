class CreateAssignedJobs < ActiveRecord::Migration
	def change
		create_table :assigned_jobs do |t|

			t.string :job_descriptoin, null: false, default: ""
			t.integer :user_id
			t.integer :video_id

			t.timestamps null: false
		end
	end
end
