class FixLegacyBooleans < ActiveRecord::Migration[8.1]
  def up
    execute "UPDATE players SET active = 1 WHERE active = 't'"
    execute "UPDATE players SET active = 0 WHERE active = 'f'"
    execute "UPDATE games SET started = 1 WHERE started = 't'"
    execute "UPDATE games SET started = 0 WHERE started = 'f'"
  end

  def down
    execute "UPDATE players SET active = 't' WHERE active = 1"
    execute "UPDATE players SET active = 'f' WHERE active = 0"
    execute "UPDATE games SET started = 't' WHERE started = 1"
    execute "UPDATE games SET started = 'f' WHERE started = 0"
  end
end
