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
      # Distribute bonus points
      standings.each_with_index do |entrant, index|
        bonus = standings.size - index
        logger.debug("  -> #{(index+1).ordinal} place: #{entrant.id}, player: #{entrant.player.name}, got #{bonus} bonus points.")
        entrant.player.bonus_points += bonus
        entrant.player.save!
      end
      self.save!
    end
  end

  def self.reset_scores
    points = Hash.new {|h,k| h[k] = 0 }
    bonus_points = Hash.new{|h,k| h[k] = 0}
    self.all.each do |game|
       entrants = game.entrants.sort_by {|e| e.final_position }
       entrants.each_with_index do |entrant, idx|
         points[entrant.player.id] += 3 if idx == 0
         points[entrant.player.id] += 2 if idx == 1
         points[entrant.player.id] += 1 if idx == 2
         points[entrant.player.id] -= 1 if idx == (entrants.size - 1)
         bonus_points[entrant.player.id] += entrants.size - idx
       end
    end
    Player.all.each do |player|
      player.points = points[player.id] || 0
      player.bonus_points = bonus_points[player.id] || 0
      player.save!
    end
  end
end
