class CreateCacheRequests < ActiveRecord::Migration
  def self.up
    create_table :cache_requests do |t|
      t.string :key
      t.text :value

      t.timestamps
    end
  end

  def self.down
    drop_table :cache_requests
  end
end
