class SessionsController < ApplicationController
  def new
    @users = User.all
  end

  def create
    @users = User.all
    user = User.find_by(name: params[:name])
    if user and user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to index_url
    else
      redirect_to login_url#, alert: "Неверная комбинация имени и пароля"
    end
  end

  def destroy
    @users = User.all
    session[:user_id] = nil
    redirect_to index_url#, notice: "Сеанс работы завершен"
  end
end
