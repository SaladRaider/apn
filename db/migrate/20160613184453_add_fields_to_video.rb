class AddFieldsToVideo < ActiveRecord::Migration
  def change
  	add_column :videos, :bite, :text
  	add_column :videos, :duration, :string
  	add_column :videos, :computer, :string
  end
end
