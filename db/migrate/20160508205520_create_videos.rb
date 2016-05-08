class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :title
      t.integer :show
      t.string :link
      t.text :description
      t.string :keywords
      t.integer :category

      t.timestamps null: false
    end
  end
end
