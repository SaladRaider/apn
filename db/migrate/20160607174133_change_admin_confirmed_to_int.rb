class ChangeAdminConfirmedToInt < ActiveRecord::Migration
  def up
  	add_column :users, :convert_admin_confirmed, :integer, :default => true

    Project.all.each do |p|
      if p.admin_confirmed
        p.convert_admin_confirmed = 1
      else
        p.convert_admin_confirmed = 0
      end
    end

    remove_column :users, :admin_confirmed
    rename_column :users, :convert_admin_confirmed, :admin_confirmed
  end

  def down
    change_column :users, :admin_confirmed, :boolean
  end

end
