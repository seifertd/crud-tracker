class GamesController < ApplicationController
  # GET /games
  # GET /games.xml
  def index
    @games = Game.order('created_at desc, updated_at desc').paginate(:page => params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @games }
      format.json  { render :xml => @games.to_json }
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
    @game = Game.new((params[:game] || {}).merge({:started => true}))

    entrant_ids = (params[:player_ids] || []).uniq
    entrant_ids.shuffle! if params[:shuffle]
    position = 1
    @game.entrants = entrant_ids.map do |player_id|
      entrant = Entrant.new(:player_id => player_id, :position => position)
      position += 1
      entrant
    end

    redirect_to_obj = @game

    respond_to do |format|
      if @game.save
        if params[:commit] == 'Record Final Result'
          @game.finish
          @game.save
          redirect_to_obj = games_url
        end
        format.html { redirect_to(redirect_to_obj, :notice => 'Game was successfully created.') }
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
      redirect_to_obj = @game
      notice_text = 'Game was successfully updated.'
      if params[:submit] == 'game over'
        @game.game_over(params[:entrant_ids])
      elsif params[:submit] == 'End Game Now'
        @game.finish
        notice_text = 'Game was ended'
        redirect_to_obj = games_url
      else
        # Reset players
        entrant_ids = (params[:player_ids] || []).uniq
        position = 1
        new_entrants = entrant_ids.map do |player_id|
          entrant = @game.entrants.find_by_player_id(player_id) || Entrant.new(:player_id => player_id, :position => position)
          unless entrant.new_record?
            entrant.update_attribute(:position, position)
          end
          position += 1
          entrant
        end
        @game.entrants = new_entrants
      end

      if @game.save
        format.html { redirect_to(redirect_to_obj, :notice => notice_text) }
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
