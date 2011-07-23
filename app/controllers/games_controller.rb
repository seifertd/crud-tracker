class GamesController < ApplicationController
  # GET /games
  # GET /games.xml
  def index
    @games = Game.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @games }
    end
  end

  # GET /games/1
  # GET /games/1.xml
  def show
    @game = Game.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @game }
    end
  end

  # GET /games/new
  # GET /games/new.xml
  def new
    @game = Game.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @game }
    end
  end

  # GET /games/1/edit
  def edit
    @game = Game.find(params[:id])
  end

  # POST /games
  # POST /games.xml
  def create
    @game = Game.new(:started => true)

    entrant_ids = params[:entrant_ids]
    entrant_ids.shuffle! if params[:shuffle]
    position = 1
    @game.entrants = params[:entrant_ids].map do |player_id|
      entrant = Entrant.new(:player_id => player_id, :position => position)
      position += 1
      entrant
    end

    respond_to do |format|
      if @game.save
        format.html { redirect_to(@game, :notice => 'Game was successfully created.') }
        format.xml  { render :xml => @game, :status => :created, :location => @game }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @game.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /games/1
  # PUT /games/1.xml
  def update
    @game = Game.find(params[:id])
    respond_to do |format|
      if params[:submit] == 'inning over'
        position = @game.entrants.size
        params[:entrant_ids].each_with_index do |entrant_id, idx|
          entrant = Entrant.find(entrant_id);
          entrant.position = position - idx
          entrant.send("inning_#{@game.inning}_position=", idx + 1)
          entrant.save!
        end
        @game.inning += 1
        if @game.inning >= 3
          @game.started = false
        end
      end
      if @game.save
        format.html { redirect_to(@game, :notice => 'Game was successfully updated.') }
        format.xml  { head :ok }
        format.json { render :json => @game.to_json(:include => :entrants), :layout => false }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @game.errors, :status => :unprocessable_entity }
        format.json { render :json => {:error => true}.to_json, :layout => false }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.xml
  def destroy
    @game = Game.find(params[:id])
    @game.destroy

    respond_to do |format|
      format.html { redirect_to(games_url) }
      format.xml  { head :ok }
    end
  end
end
