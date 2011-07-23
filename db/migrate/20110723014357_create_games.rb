class CreateGames < ActiveRecord::Migration
  def self.up
    create_table :games do |t|
      t.boolean :started, :null => false, :default => false
      t.integer :inning, :null => false, :default => 1
      t.timestamps
    end
  end

  def self.down
    drop_table :games
  end
end
