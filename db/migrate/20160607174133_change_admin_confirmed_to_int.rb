class ChangeAdminConfirmedToInt < ActiveRecord::Migration
  def change
  	change_column :users, :admin_confirmed, :integer
  end
end
