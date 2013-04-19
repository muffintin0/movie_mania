class SessionsController < ApplicationController

  def new
    redirect_to '/auth/twitter'
  end

  def create
    auth = request.env["omniauth.auth"]
    user = User.where(:provider => auth['provider'],
                      :uid => auth['uid']).first || User.create_with_omniauth(auth)
    session[:user_id] = user.id
    if user.email.blank?
      redirect_to edit_user_path(user), :alert => 'Please enter your email address.'
    else
      flash[:success] = "Signed in!"
      redirect_to root_url
    end
  end
  
  def destroy
    reset_session
    flash[:success] = "Signed out!"
    redirect_to root_url
  end
  
  def failure
    redirect_to root_url, :alert => "Authentication error: #{params[:message].humanize}"
  end
end
