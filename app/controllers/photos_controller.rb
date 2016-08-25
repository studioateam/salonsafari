class PhotosController < ApplicationController
  require 'fileutils'
  skip_before_action :authorize, only: [:index, :show]
  before_action :set_photo, only: [:show, :edit, :update, :destroy]

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

    path_to_dir = Rails.root.join('app', 'assets', 'images', @photo.name)    

    FileUtils::mkdir_p path_to_dir

    uploaded_cover = @photo.cover

    filename_cover = @photo.cover.original_filename
    @photo.cover = filename_cover

    data = uploaded_cover.read

    File.open(Rails.root.join('app', 'assets', 'images', @photo.name, filename_cover), 'wb') do|f|
        f.write(data)
    end

    paths = ""
    if !params[ :files ].nil?
    	  params[ :files ].each{ |file|
	     filename = file.original_filename
    	     paths = paths + filename + ";"
	     File.open(Rails.root.join('app', 'assets', 'images', @photo.name, filename), 'wb') do|f|
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
	File.delete(Rails.root.join('app', 'assets', 'images', @photo.name, path_to_image))
    }

    File.delete(Rails.root.join('app', 'assets', 'images', @photo.name, @photo.cover))

    FileUtils.rm_rf(Rails.root.join('app', 'assets', 'images', @photo.name))

    @photo.destroy
    respond_to do |format|
      format.html { redirect_to photos_url }
      format.json { head :no_content }
    end
  end

  def add_photo_to_folder
    url = request.original_url

    @photo = Photo.new
   
    session[:photo_id] = url.split('.').last()

    photo = Photo.find_by(id: session[:photo_id])

    @id_photo = url.split('.').last()
	
  end
  
  def add_photo_to_folder_post

    photo = Photo.find_by(id: session[:photo_id])

        
    path_to_folder = Rails.root.join('app', 'assets', 'images', photo.name)

    records = Dir.glob(path_to_folder.to_s + "/**/*" )

    old_photos = photo.image_paths
    
    paths = ""
    if !params[ :files ].nil?
    	  params[ :files ].each{ |file|
	     filename = file.original_filename
	     path_to_adding_file = Rails.root.join('app', 'assets', 'images', photo.name, filename).to_s
	     
	     is_found = false
	     added_value = rand(0..199).to_s

	     records.each { |exist_file|

		if exist_file == path_to_adding_file
			is_found = true
			added_value = rand(0..199).to_s
			while exist_file == Rails.root.join('app', 'assets', 'images', photo.name, added_value + '_' + filename).to_s
				added_value = rand(0..199).to_s
			end
		end
    	     }
	     
	     if is_found
             	filename = added_value + '_' + filename
	     end

	     if filename.to_s.include? "."
    	     	paths = paths + filename + ";"
	     end

	     File.open(Rails.root.join('app', 'assets', 'images', photo.name, filename), 'wb') do|f|
		f.write(file.read)
	     end
    	  }
    end

    photo.image_paths = old_photos + ";" + paths[0...-1]

    is_bad = false
    mass = photo.image_paths.split(';')
    new_array = mass.uniq
    if mass.length != new_array.length
	is_bad = true
    end
    
    if !is_bad
    	photo.save
    else
	redirect_to comments_path_url
    end

    session[:photo_id] = -1
   
    redirect_to photos_url

  end

  def delete_photo_from_folder
	url = request.original_url
	  
	session[:photo_id] = url.split('.').last()
	
	photo = Photo.find_by(id: session[:photo_id])
	
	@photo_name = photo.name

	@list_of_photo = photo.image_paths.split(';')
  end

  def delete_photo_from_folder_post
	
	url = request.original_url
	  
	i = url.split('.').last().to_i
	
	photo = Photo.find_by(id: session[:photo_id])
	
	list_of_photos = photo.image_paths.split(';')

	element = list_of_photos[i]
	File.delete(Rails.root.join('app', 'assets', 'images', photo.name, element))	
	
	list_of_photos.delete(element)

	paths = ""
	list_of_photos.each { |item|
		paths = paths + item + ";"
	}

	photo.image_paths = paths[0...-1]

	photo.save

	redirect_to photos_url
	
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
