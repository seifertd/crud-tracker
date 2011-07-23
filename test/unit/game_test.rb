require 'test_helper'

class GameTest < ActiveSupport::TestCase
  def setup
    @game = games(:finished_game)
  end

  def test_scoring_points
    assert_equal 5, @game.entrants.size, 'There should be five entrants in the finished game'
    assert @game.started, "Game should be ongoing"

    finish_order_entrants = [entrants(:fg_1), entrants(:fg_2), entrants(:fg_3), entrants(:fg_4), entrants(:fg_5)]
    finish_order = finish_order_entrants.map(&:id)
    before_points = finish_order_entrants.map{|e| e.player.points}

    @game.inning_over(finish_order)
    @game.save!
    # Reload from db
    @game = Game.find(@game.id)

    assert !@game.started, "Game should be over"
    assert_equal 3, @game.inning, "Game inning should have incremented"

    # Reload entrants from db
    after_entrants = finish_order_entrants.map{|e| Entrant.find(e.id)}
    after_points = after_entrants.map{|e| e.player.points}

    after_entrants.each_with_index do |entrant, idx|
      assert_equal idx+1, entrant.inning_2_position
    end

    # First three entrants should have scored 4 points each
    [0,1,2].each do |index|
      assert_equal 4, after_points[index] - before_points[index]
    end
    # fourth entrant should have scored nothing
    assert_equal 0, after_points[3] - before_points[3]
    # last entrant should have scored -2
    assert_equal -2, after_points[4] - before_points[4]
  end

end
