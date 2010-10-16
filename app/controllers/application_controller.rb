require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery

  layout :layout_by_resource
  def layout_by_resource
    if devise_controller? and !(controller_name.to_sym == :registrations and action_name.to_sym == :edit)
      "sessions"
    else
      "application"
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = exception.message
    redirect_to new_user_session_url
  end

end
