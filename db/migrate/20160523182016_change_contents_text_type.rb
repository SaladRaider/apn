class ChangeContentsTextType < ActiveRecord::Migration
  def up
    change_column :contents, :text, :text, :default => nil
  end

  def down
    change_column :contents, :text, :string, :default => ''
  end
end
