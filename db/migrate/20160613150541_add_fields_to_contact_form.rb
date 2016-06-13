class AddFieldsToContactForm < ActiveRecord::Migration
  def change
  	add_column :contacts, :org_club, :string
  	add_column :contacts, :sub_date, :date
  	add_column :contacts, :id_number, :integer
  end
end
