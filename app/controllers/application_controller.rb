class ApplicationController < ActionController::Base
  protect_from_forgery

  private

    def current_user
      @current_user ||= begin
        User.find_by_id(session[:user_id]) if session[:user_id]
      end
    end
    helper_method :current_user
end
