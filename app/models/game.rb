class Game < ActiveRecord::Base
  has_many :entrants, :order => 'position asc', :dependent => :delete_all
  has_many :players, :through => :entrants

  def available_players
    (Player.all - players).sort_by(&:display_name)
  end

  def inning_over(standings)
    logger.debug("Game #{self.id}: end of inning #{self.inning}")
    self.transaction do
      position = entrants.size
      standings.each_with_index do |entrant_id, idx|
        entrant = Entrant.find(entrant_id);
        entrant.position = position - idx
        entrant.send("inning_#{self.inning}_position=", idx + 1)
        logger.debug("  -> Entrant #{entrant.id}, player: #{entrant.player.name}, position: #{entrant.position}")
        entrant.save!
      end
      self.inning += 1
      if self.inning >= 3
        finish
      end
    end
  end

  def finish
    logger.debug("Game #{self.id} has finished")
    self.started = false
    [1,2].each do |finished_inning|
      logger.debug(" -> Inning #{finished_inning}")
      standings = entrants.sort_by(&"inning_#{finished_inning}_position".to_sym)
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
    end
  end
end
