class AddGuidToWidgets < ActiveRecord::Migration
  def self.up
    add_column :widgets, :guid, :string
  end

  def self.down
    remove_column :widgets, :guid
  end
end
