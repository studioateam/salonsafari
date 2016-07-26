class PhotosController < ApplicationController
  skip_before_action :authorize, only: [:index, :show]
  before_action :set_photo, only: [:show, :edit, :update, :destroy]
  require 'securerandom'

  # GET /photos
  # GET /photos.json
  def index
    @users = User.all
    @photos = Photo.all
  end

  # GET /photos/1
  # GET /photos/1.json
  def show
    @users = User.all
  end

  # GET /photos/new
  def new
    @users = User.all
    @photo = Photo.new

    if !session[:user_id]
	redirect_to index_url
    end
  end

  # GET /photos/1/edit
  def edit
    @users = User.all

    if !session[:user_id]
	redirect_to index_url
    end
  end

  # POST /photos
  # POST /photos.json
  def create
    @users = User.all

    if !session[:user_id]
	redirect_to index_url
    end
    @photo = Photo.new(photo_params)

    uploaded_cover = @photo.cover

    filename_cover = SecureRandom.hex + "_" + @photo.cover.original_filename
    @photo.cover = filename_cover

    data = uploaded_cover.read

    File.open(Rails.root.join('app', 'assets', 'images', filename_cover), 'wb') do|f|
        f.write(data)
    end

    paths = ""
    if !params[ :files ].nil?
    	  params[ :files ].each{ |file|
	     filename = SecureRandom.hex + "_" + file.original_filename
    	     paths = paths + filename + ";"
	     File.open(Rails.root.join('app', 'assets', 'images', filename), 'wb') do|f|
        	f.write(file.read)
	     end
    	  }
   end
  
   @photo.image_paths = paths[0...-1]

    respond_to do |format|
      if @photo.save
        format.html { redirect_to photos_url, notice: 'Photo was successfully created.' }
        format.json { render action: 'show', status: :created, location: @photo }
      else
        format.html { render action: 'new' }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /photos/1
  # PATCH/PUT /photos/1.json
  def update
    @users = User.all

    if !session[:user_id]
	redirect_to index_url
    end
    respond_to do |format|
      if @photo.update(photo_params)
        format.html { redirect_to photos_url, notice: 'Photo was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /photos/1
  # DELETE /photos/1.json
  def destroy
    @users = User.all
    
    if !session[:user_id]
	redirect_to index_url
    end

    photo_paths = @photo.image_paths.split(';')
    photo_paths.each{ |path_to_image|
	File.delete(Rails.root.join('app', 'assets', 'images', path_to_image))
    }

    File.delete(Rails.root.join('app', 'assets', 'images', @photo.cover))

    @photo.destroy
    respond_to do |format|
      format.html { redirect_to photos_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_photo
      @photo = Photo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def photo_params
      params.require(:photo).permit(:name, :description, :image_paths, :cover)
    end
end
