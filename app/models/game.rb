class Game < ActiveRecord::Base
  has_many :entrants, :order => 'position asc', :dependent => :delete_all
  has_many :players, :through => :entrants

  def available_players
    (Player.all - players).sort_by(&:display_name)
  end

  def inning_over(standings)
    self.transaction do
      position = entrants.size
      standings.each_with_index do |entrant_id, idx|
        entrant = Entrant.find(entrant_id);
        entrant.position = position - idx
        entrant.send("inning_#{self.inning}_position=", idx + 1)
        entrant.save!
      end
      self.inning += 1
      if self.inning >= 3
        finish
      end
    end
  end

  def finish
    self.started = false
    [1,2].each do |finished_inning|
      standings = entrants.sort_by(&"inning_#{finished_inning}_position".to_sym)
      standings.last.player.points ||= 0
      standings.last.player.points -= 1
      standings.last.player.save!
      standings[0,3].each_with_index do |entrant, index|
        entrant.player.points ||= 0
        entrant.player.points += (3-index)
        entrant.player.save!
      end
    end
  end
end
