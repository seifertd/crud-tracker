class HomeController < ApplicationController
  def index
    @active_games = Game.where(started: true).order(created_at: :desc).includes(entrants: :player)
    @recent_games = Game.completed.order(updated_at: :desc).limit(5).includes(entrants: :player)
    @top_players = Player.active.includes(:entrants).select { |p| p.ppg }.sort_by { |p| -p.ppg }.first(5)
  end

end
