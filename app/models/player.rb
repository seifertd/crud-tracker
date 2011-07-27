class Player < ActiveRecord::Base
  has_many :entrants
  has_many :games, :through => :entrants
  validates_uniqueness_of :name
  validates_uniqueness_of :nickname, :allow_blank => true

  def display_name
    @display_name ||= begin
      display_name = "#{name}"
      display_name << " (#{nickname})" unless nickname.blank?
      display_name
    end
  end

  def games_played
    @games_played ||= entrants.inject(0) do |sum, entrant|
      sum += (entrant.inning_1_position ? 1 : 0) + (entrant.inning_2_position ? 1 : 0)
    end
  end

  def win_percentage
    if games_played > 0
      wins = entrants.inject(0) {|sum, entrant| sum += ((entrant.inning_1_position == 1 ? 1 : 0) + (entrant.inning_2_position == 1 ? 1 : 0))}
      wins.to_f / games_played * 100.0
    else
      nil
    end
  end

  def place_percentage
    if games_played > 0
      wins = entrants.inject(0) {|sum, entrant| sum += ((entrant.inning_1_position == 2 ? 1 : 0) + (entrant.inning_2_position == 2 ? 1 : 0))}
      wins.to_f / games_played * 100.0
    else
      nil
    end
  end

  def show_percentage
    if games_played > 0
      wins = entrants.inject(0) {|sum, entrant| sum += ((entrant.inning_1_position == 3 ? 1 : 0) + (entrant.inning_2_position == 3 ? 1 : 0))}
      wins.to_f / games_played * 100.0
    else
      nil
    end
  end

  def last_percentage
    if games_played > 0
      wins = entrants.inject(0) {|sum, entrant| num_entrants = entrant.game.entrants.size; sum += ((entrant.inning_1_position == num_entrants ? 1 : 0) + (entrant.inning_2_position == num_entrants ? 1 : 0))}
      wins.to_f / games_played * 100.0
    else
      nil
    end
  end
end
