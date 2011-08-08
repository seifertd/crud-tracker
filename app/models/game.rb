class Game < ActiveRecord::Base
  has_many :entrants, :order => 'position asc', :dependent => :delete_all
  has_many :players, :through => :entrants

  def available_players
    (Player.all - players).sort_by(&:display_name)
  end

  def game_over(standings)
    return unless self.started
    logger.debug("Game #{self.id}: end of game")
    self.transaction do
      position = entrants.size
      standings.each_with_index do |entrant_id, idx|
        entrant = Entrant.find(entrant_id);
        entrant.position = position - idx
        entrant.final_position = idx + 1
        logger.debug("  -> Entrant #{entrant.id}, player: #{entrant.player.name}, position: #{entrant.position}, final_position: #{entrant.final_position}")
        entrant.save!
      end
      self.started = false
      standings = entrants.sort_by(&:final_position)
      logger.debug("  -> Last place: #{standings.last.id}, player: #{standings.last.player.name}, points before: #{standings.last.player.points}")
      standings.last.player.points ||= 0
      standings.last.player.points -= 1
      standings.last.player.save!
      logger.debug("  -> Last place: #{standings.last.id}, player: #{standings.last.player.name}, points after: #{standings.last.player.points}")
      standings[0,3].each_with_index do |entrant, index|
        logger.debug("  -> #{(index+1).ordinal} place: #{entrant.id}, player: #{entrant.player.name}, points before: #{entrant.player.points}")
        entrant.player.points ||= 0
        entrant.player.points += (3-index)
        entrant.player.save!
        logger.debug("  -> #{(index+1).ordinal} place: #{entrant.id}, player: #{entrant.player.name}, points after: #{entrant.player.points}")
      end
      self.save!
    end
  end

  def self.reset_scores
    points = Hash.new {|h,k| h[k] = 0 }
    self.all.each do |game|
       entrants = game.entrants.sort_by {|e| e.final_position }
       points[entrants.first.player.id] += 3
       points[entrants[1].player.id] += 2
       points[entrants[2].player.id] += 1
       points[entrants.last.player.id] -= 1
    end
    Player.all.each do |player|
      player.points = points[player.id]
      player.save!
    end
  end
end
