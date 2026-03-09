class Player < ActiveRecord::Base
  has_many :entrants, :dependent => :destroy
  has_many :games, :through => :entrants
  validates_uniqueness_of :name
  validates_uniqueness_of :nickname, :allow_blank => true
  MIN_GAMES_TO_SCORE = 5

  def self.active
    where(:active => true)
  end

  def completed_entrants
    entrants.joins("join games on games.id = entrants.game_id").where("games.started = 'f'")
  end

  def display_name
    @display_name ||= begin
      display_name = "#{name}"
      display_name << " (#{nickname})" unless nickname.blank?
      display_name
    end
  end

  def games_played
    @games_played ||= entrants.count
  end

  def ppg
    @ppg ||= if games_played >= MIN_GAMES_TO_SCORE
      points.to_f / games_played
    else
      nil
    end
  end

  def ppg_with_bonus
    @ppg_with_bonus ||= if games_played >= MIN_GAMES_TO_SCORE
      ((points || 0) + (bonus_points || 0)).to_f / games_played
    else
      nil
    end
  end

  def win_percentage
    if games_played > 0
      wins = entrants.inject(0) {|sum, entrant| sum += (entrant.final_position == 1 ? 1 : 0) }
      wins.to_f / games_played * 100.0
    else
      nil
    end
  end

  def place_percentage
    if games_played > 0
      wins = entrants.inject(0) {|sum, entrant| sum += (entrant.final_position == 2 ? 1 : 0) }
      wins.to_f / games_played * 100.0
    else
      nil
    end
  end

  def show_percentage
    if games_played > 0
      wins = entrants.inject(0) {|sum, entrant| sum += (entrant.final_position == 3 ? 1 : 0) }
      wins.to_f / games_played * 100.0
    else
      nil
    end
  end

  def last_percentage
    if games_played > 0
      wins = entrants.inject(0) {|sum, entrant| num_entrants = entrant.game.entrants.count; sum += (entrant.final_position == num_entrants ? 1 : 0) }
      wins.to_f / games_played * 100.0
    else
      nil
    end
  end
end
