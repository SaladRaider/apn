class ChangeAdminConfirmedToInt < ActiveRecord::Migration
  def change
  	change_column :users, :admin_confirmed, 'integer USING CAST(admin_confirmed AS integer)'
  end
end
