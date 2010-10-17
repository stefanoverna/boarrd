class AddColumnsCountToDashboards < ActiveRecord::Migration
  def self.up
    add_column :dashboards, :columns_count, :integer
  end

  def self.down
    remove_column :dashboards, :columns_count
  end
end
