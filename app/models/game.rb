class Game < ActiveRecord::Base
  has_many :entrants, :order => 'position asc', :dependent => :delete_all
  has_many :players, :through => :entrants

  def available_players
    (Player.all - players).sort_by(&:display_name)
  end
end
