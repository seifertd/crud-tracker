class PlayersController < ApplicationController
  # GET /players
  def index
    @players = Player.all

    @sort_criteria = (params[:sort] || 'ppg').to_sym

    @players = @players.sort_by do |player|
      [player.active ? -1 : 1, 0.0 - (player.send(@sort_criteria) || -1000), 0.0 - (player.win_percentage || -1000), 0.0 - (player.place_percentage || -1000), 0.0 - (player.show_percentage || -1000), player.last_percentage || -1000, player.name ]
    end

    respond_to do |format|
      format.html
      format.json do
        json = @players.map do |player|
          {
            player_id: player.id,
            name: player.name,
            nickname: player.nickname,
            points: player.points,
            games_played: player.games_played,
            ppg: player.ppg,
            ppg_with_bonus: player.ppg_with_bonus,
            win_percentage: player.win_percentage,
            place_percentage: player.place_percentage,
            show_percentage: player.show_percentage,
            last_percentage: player.last_percentage
          }
        end
        render json: json
      end
      format.xml { render xml: @players }
    end
  end

  # GET /players/1
  def show
    @player = Player.find(params[:id])
    @entries = @player.completed_entrants.order('entrants.created_at desc').paginate(page: params[:page], per_page: 10)

    respond_to do |format|
      format.html
      format.xml { render xml: @player }
    end
  end

  # GET /players/new
  def new
    @player = Player.new

    respond_to do |format|
      format.html
      format.xml { render xml: @player }
    end
  end

  # GET /players/1/edit
  def edit
    @player = Player.find(params[:id])
  end

  # POST /players
  def create
    @player = Player.new(params[:player].permit(:name, :nickname))

    respond_to do |format|
      if @player.save
        format.html { redirect_to(@player, notice: 'Player was successfully created.') }
        format.xml  { render xml: @player, status: :created, location: @player }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.xml  { render xml: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /players/1
  def update
    @player = Player.find(params[:id])

    respond_to do |format|
      if @player.update(params[:player].permit(:name, :nickname, :active))
        format.html { redirect_to(@player, notice: 'Player was successfully updated.') }
        format.js
        format.xml  { head :ok }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.xml  { render xml: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /players/1
  def destroy
    @player = Player.find(params[:id])
    @player.destroy

    respond_to do |format|
      format.html { redirect_to(players_url) }
      format.xml  { head :ok }
    end
  end
end
