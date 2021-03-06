class TracksController < ApplicationController
  # GET /tracks
  # GET /tracks.json
  before_filter :authenticate_user!

  def index
    if params[:id] != nil
      @tracks = Playlist.find(params[:id]).tracks.reverse!
      @playlist = Playlist.find(params[:id])
    else
      @tracks = Track.all.reverse!
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tracks }
    end
  end

  # GET /tracks/1
  # GET /tracks/1.json
  def show
    @track = Track.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @track }
    end
  end

  # GET /tracks/new
  # GET /tracks/new.json
  def new
    @track = Track.new
    # authorize! :new, @track

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @track }
    end
  end

  # GET /tracks/1/edit
  def edit
    @track = Track.find(params[:id])
    # authorize! :edit, @track

  end

  # POST /tracks
  # POST /tracks.json
  def create
    client = Soundcloud.new(:client_id => '44eb1fb2fd831aed03620d757489bdd6')
    params[:track][:user_id] = current_user.id
    track_url = params[:track][:url]
    track = client.get('/resolve', :url => track_url)
    params[:track][:duration] = track.duration
    # params[:track][:duration] = 
    @track = Track.new(params[:track])
    # authorize! :create, @track

    respond_to do |format|
      if @track.save
        format.html { redirect_to @track, notice: 'Track was successfully created.' }
        format.json { render json: @track, status: :created, location: @track }
      else
        format.html { render action: "new" }
        format.json { render json: @track.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tracks/1
  # PUT /tracks/1.json
  def update
    @track = Track.find(params[:id])

    respond_to do |format|
      if @track.update_attributes(params[:track])
        format.html { redirect_to @track, notice: 'Track was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @track.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tracks/1
  # DELETE /tracks/1.json
  def destroy
    @track = Track.find(params[:id])
    @track.destroy

    respond_to do |format|
      format.html { redirect_to tracks_url }
      format.json { head :no_content }
    end
  end
end
