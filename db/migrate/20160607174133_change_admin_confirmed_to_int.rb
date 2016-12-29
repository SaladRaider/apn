class ChangeAdminConfirmedToInt < ActiveRecord::Migration
  def change
  	change_column :users, :admin_confirmed, 'integer USING CAST(column_name AS integer)'
  end
end
