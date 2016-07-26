class AdminController < ApplicationController
  skip_before_action :authorize
  require 'digest/md5'
  

  def index
  end

  def index_post
	password = params[:password]
	md5_password = Digest::MD5.hexdigest(password)
	
	@is_success = false
	if md5_password == '13dd91944ff12bc3387dd3cc3efacd4b'
		@is_success = true
	end

	session[:is_success] = @is_success

	redirect_to index_path
  end
end
