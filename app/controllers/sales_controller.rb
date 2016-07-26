class SalesController < ApplicationController
  skip_before_action :authorize, only: [:index]
  before_action :set_sale, only: [:show, :edit, :update, :destroy]

  # GET /sales
  # GET /sales.json
  def index
    @users = User.all
    @sales = Sale.all
  end

  # GET /sales/1
  # GET /sales/1.json
  def show
    @users = User.all

    if !session[:user_id]
	redirect_to index_url
    end
  end

  # GET /sales/new
  def new
    @users = User.all
    @sale = Sale.new

    if !session[:user_id]
	redirect_to index_url
    end
  end

  # GET /sales/1/edit
  def edit
    @users = User.all

    if !session[:user_id]
	redirect_to index_url
    end
  end

  # POST /sales
  # POST /sales.json
  def create
    @users = User.all

    if !session[:user_id]
	redirect_to index_url
    end
    @sale = Sale.new(sale_params)

    respond_to do |format|
      if @sale.save
        format.html { redirect_to sales_url, notice: 'Sale was successfully created.' }
        format.json { render action: 'show', status: :created, location: @sale }
      else
        format.html { render action: 'new' }
        format.json { render json: @sale.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sales/1
  # PATCH/PUT /sales/1.json
  def update
    @users = User.all

    if !session[:user_id]
	redirect_to index_url
    end

    respond_to do |format|
      if @sale.update(sale_params)
        format.html { redirect_to sales_url, notice: 'Sale was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @sale.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sales/1
  # DELETE /sales/1.json
  def destroy
    @users = User.all

    if !session[:user_id]
	redirect_to index_url
    end

    @sale.destroy
    respond_to do |format|
      format.html { redirect_to sales_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sale
      @sale = Sale.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sale_params
      params.require(:sale).permit(:title, :description)
    end
end
