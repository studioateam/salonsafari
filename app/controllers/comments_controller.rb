class CommentsController < ApplicationController
  skip_before_action :authorize, only: [:index]
  before_action :set_comment, only: [:show, :edit, :update, :destroy]

  # GET /comments
  # GET /comments.json
  def index
    @users = User.all
    @comments = Comment.order('created_at desc').paginate(:page => params[:page], :per_page => 7)
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
    @users = User.all

    if !session[:user_id]
	redirect_to index_url
    end
  end

  # GET /comments/new
  def new
    @users = User.all
    @comment = Comment.new
    Time.zone = "Europe/Volgograd"
    @time = Time.current
  end

  # GET /comments/1/edit
  def edit
    @users = User.all

    if !session[:user_id]
	redirect_to index_url
    end
  end

  # POST /comments
  # POST /comments.json
  def create
    @users = User.all

    @comment = Comment.new(comment_params)

    respond_to do |format|
      if @comment.save
        format.html { redirect_to comments_path }#, notice: 'Comment was successfully created.' }
        #format.json { render action: 'show', status: :created, location: @comment }
      else
        format.html { render action: 'new' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    @users = User.all

    if !session[:user_id]
	redirect_to index_url
    end

    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to comments_path, notice: 'Comment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @users = User.all


    if !session[:user_id]
	redirect_to index_url
    end

    @comment.destroy
    respond_to do |format|
      format.html { redirect_to comments_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:name, :email, :message, :message_date)
    end
end
