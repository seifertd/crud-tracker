class AddBonusPointsToPlayer < ActiveRecord::Migration
  def self.up
    add_column :players, :bonus_points, :integer, :null => false, :default => 0
    Player.reset_column_information
    transaction do
      Game.all.each do |game|
        entries = game.entrants
        entries.each_with_index do |entrant, idx|
          entrant.player.bonus_points += entries.size - idx
          entrant.player.save!
        end
      end
    end
  end

  def self.down
    remove_column :players, :bonus_points
  end
end
