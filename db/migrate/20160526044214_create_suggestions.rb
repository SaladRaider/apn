class CreateSuggestions < ActiveRecord::Migration
	def change
		create_table :suggestions do |t|
			t.string :subject
			t.text :message

			t.timestamps null: false
		end
	end
end
