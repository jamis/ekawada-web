class ApplicationController < ActionController::Base
  protect_from_forgery

  private

    def current_user
      @current_user ||= begin
        user = User.find_by_id(session[:user_id]) if session[:user_id]
        user = nil if user && user.deleted?
        user || User::Unauthenticated.new
      end
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
