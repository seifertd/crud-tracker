class GetRidOfInnings < ActiveRecord::Migration
  def self.up
    transaction do
      # Make copies of games with two inning positions set
      new_games = Hash.new do |h,k|
        h[k] = Game.create(k.attributes)
      end
      Entrant.all.each do |entry|
        if entry.inning_2_position
          new_game = new_games[entry.game]
          new_entry = Entrant.new(entry.attributes)
          new_entry.game_id = new_game.id
          new_entry.inning_1_position = new_entry.inning_2_position
          new_entry.save!
        end
      end
    end

    # Add the final_position column
    add_column :entrants, :final_position, :integer
    Entrant.reset_column_information

    # Copy all inning_1_positions as final_position
    transaction do
      Entrant.all.each do |entry|
        entry.final_position = entry.inning_1_position
        entry.save!
      end
    end

    # Now get rid of the columns
    remove_column :games, :inning
    remove_column :entrants, :inning_1_position
    remove_column :entrants, :inning_2_position

  end

  def self.down
    # Not really reversible ... :(
  end
end
