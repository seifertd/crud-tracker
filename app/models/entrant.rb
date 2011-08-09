class Entrant < ActiveRecord::Base
  belongs_to :game
  belongs_to :player
  acts_as_list :scope => :game

  def score
    case final_position
    when 1
      3
    when 2
      2
    when 3
      1
    when game.entrants.size
      -1
    end
  end
end
