class AddEntrantsCountToGames < ActiveRecord::Migration[8.0]
  def up
    add_column :games, :entrants_count, :integer, default: 0, null: false
    execute "UPDATE games SET entrants_count = (SELECT COUNT(*) FROM entrants WHERE entrants.game_id = games.id)"
  end

  def down
    remove_column :games, :entrants_count
  end
end
