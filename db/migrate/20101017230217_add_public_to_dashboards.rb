class AddPublicToDashboards < ActiveRecord::Migration
  def self.up
    add_column :dashboards, :public, :boolean, :default => false
  end

  def self.down
    remove_column :dashboards, :public
  end
end
