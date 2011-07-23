class CreateEntrants < ActiveRecord::Migration
  def self.up
    create_table :entrants do |t|
      t.integer :game_id, :null => false
      t.integer :player_id, :null => false
      t.integer :strikes, :default => 0, :null => false
      t.integer :position, :null => false, :default => 1
      t.boolean :alive, :null => false, :default => true
      t.integer :inning_1_position, :null => true
      t.timestamps
    end
  end

  def self.down
    drop_table :entrants
  end
end
