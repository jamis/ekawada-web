class SessionsController < ApplicationController
  def new
  end

  def create
    @current_user = User.authenticate(params[:user][:login], params[:user][:password])
    if @current_user
      session[:user_id] = @current_user.id
      redirect_to(root_url)
    else
      flash[:error] = "Incorrect username and/or password."
      redirect_to(new_session_url)
    end
  end

  def destroy
    session[:user_id] = nil
    @current_user = nil
    redirect_to(root_url)
  end
end
