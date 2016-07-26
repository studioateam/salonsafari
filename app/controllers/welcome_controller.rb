class WelcomeController < ApplicationController
  def index
    @users = User.all
    news = News.all.order('created_at desc')
    sales = Sale.all.order('created_at desc')
    @first_news = news.first(2)
    @first_sales = sales.first(2)
    @is_empty_news = false
    if @first_news.count == 0
      @is_empty_news = true
    end
    
    @is_empty_sales = false
    if @first_sales.count == 0
      @is_empty_sales = true
    end
  end

  def about
    @users = User.all
  end

  def affro
    @users = User.all
  end

  def chemicalperm
    @users = User.all
  end

  def contacts
    @users = User.all
  end

  def gallery
    @users = User.all
  end

  def haircare
    @users = User.all
  end

  def haircoloring
    @users = User.all
  end

  def haircut
    @users = User.all
  end

  def hairextension
    @users = User.all
  end

  def hairstyling
    @users = User.all
  end

  def makeup
    @users = User.all
  end

  def manicure
    @users = User.all
  end

  def service
    @users = User.all
  end
end
