class PlayersController < ApplicationController
  # GET /players
  # GET /players.xml
  def index
    @players = Player.all

    @sort_criteria = (params[:sort] || 'ppg').to_sym

    @players = @players.sort_by do |player|
      [0.0 - (player.send(@sort_criteria) || -1000), 0.0 - (player.win_percentage || -1000), 0.0 - (player.place_percentage || -1000), 0.0 - (player.show_percentage || -1000), player.last_percentage || -1000, player.name ]
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json do
        json = @players.map do |player|
          {
            :player_id => player.id,
            :name => player.name,
            :nickname => player.nickname,
            :points => player.points,
            :games_played => player.games_played,
            :ppg => player.ppg,
            :win_percentage => player.win_percentage,
            :place_percentage => player.place_percentage,
            :show_percentage => player.show_percentage,
            :last_percentage => player.last_percentage
          }
        end
        render :json => json
      end
      format.xml  { render :xml => @players }
    end
  end

  # GET /players/1
  # GET /players/1.xml
  def show
    @player = Player.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @player }
    end
  end

  # GET /players/new
  # GET /players/new.xml
  def new
    @player = Player.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @player }
    end
  end

  # GET /players/1/edit
  def edit
    @player = Player.find(params[:id])
  end

  # POST /players
  # POST /players.xml
  def create
    @player = Player.new(params[:player])

    respond_to do |format|
      if @player.save
        format.html { redirect_to(@player, :notice => 'Player was successfully created.') }
        format.xml  { render :xml => @player, :status => :created, :location => @player }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @player.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /players/1
  # PUT /players/1.xml
  def update
    @player = Player.find(params[:id])

    respond_to do |format|
      if @player.update_attributes(params[:player])
        format.html { redirect_to(@player, :notice => 'Player was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @player.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /players/1
  # DELETE /players/1.xml
  def destroy
    @player = Player.find(params[:id])
    @player.destroy

    respond_to do |format|
      format.html { redirect_to(players_url) }
      format.xml  { head :ok }
    end
  end
end
