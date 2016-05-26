class CreateContents < ActiveRecord::Migration
	def change
		create_table :contents do |t|
			t.string :text, null: false, default: ""
			t.attachment :media
			t.timestamps null: false
		end
	end
end
