class ApplicationController < ActionController::Base
  protect_from_forgery

  private

    # FIXME!!!
    def current_user
      User.first
    end
end
