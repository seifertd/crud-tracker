require 'test_helper'

class GamesControllerTest < ActionController::TestCase
  setup do
    @game = games(:one)
    @players = Player.all
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:games)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create game" do
    assert_difference('Game.count') do
      post :create, :game => nil, :entrant_ids => @players.map(&:id), :shuffle => false
    end

    assert_redirected_to game_path(assigns(:game))

    new_game = assigns(:game)
    assert_equal 3, new_game.players.size
    assert_equal @players.map(&:id), new_game.entrants.map{|e| e.player.id}
    assert_equal [1,2,3], new_game.entrants.map(&:position)
  end

  test "should show game" do
    get :show, :id => @game.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @game.to_param
    assert_response :success
  end

  test "should update game" do
    put :update, :id => @game.to_param, :game => @game.attributes
    assert_redirected_to game_path(assigns(:game))
  end

  test "should destroy game" do
    assert_difference('Game.count', -1) do
      delete :destroy, :id => @game.to_param
    end

    assert_redirected_to games_path
  end
end
