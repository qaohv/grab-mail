class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include ApplicationHelper

  protected
    def after_sign_in_path_for(current_user)
      dashboard_path
    end
end
