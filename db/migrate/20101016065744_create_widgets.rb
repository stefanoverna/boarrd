class CreateWidgets < ActiveRecord::Migration
  def self.up
    create_table :widgets do |t|
      t.string :area
      t.integer :area_position
      t.string :widget_type
      t.string :input_type
      t.text :settings
      t.references :dashboard
      t.timestamps
    end
  end

  def self.down
    drop_table :widgets
  end
end
