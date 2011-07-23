class AddInning2Position < ActiveRecord::Migration
  def self.up
    add_column :entrants, :inning_2_position, :integer, :null => true
  end

  def self.down
    remove_column :entrants, :inning_2_position
  end
end
