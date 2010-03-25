class ApplicationController < ActionController::Base
  protect_from_forgery

  private

    def current_user
      @current_user ||= User.for(session[:user_id])
    end
    helper_method :current_user

    def can_alter_data?
      current_user.authenticated?
    end
    helper_method :can_alter_data?

    def ensure_can_alter_data
      return true if can_alter_data?
      render :status => :forbidden, :text => "you do not have permission to do that"
    end
end
