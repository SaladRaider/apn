class ChangeAdminConfirmedToInt < ActiveRecord::Migration
  def change
  	change_column :users, :admin_confirmed, 'integer USING CASE admin_confirmed WHEN \'true\' THEN 1 ELSE 0 END'
  end
end
