class AddViewToVideos < ActiveRecord::Migration
  def change
  	add_column :videos, :views, :integer, :null => false, default: "0"
  end
end
