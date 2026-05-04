class AddActiveToPlayers < ActiveRecord::Migration[4.2]
  def change
    add_column :players, :active, :boolean, :null => false, :default => true
  end
end
