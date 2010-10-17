require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = exception.message
    redirect_to new_user_session_url
  end

  def after_sign_in_path_for(resource_or_scope)
    dashboards_url
  end

  before_filter do
    @title = case "#{self.controller_name}##{self.action_name}"
      when "registrations#new"
        "Sign up to Boardd!"
      when "registrations#edit"
        "Edit Profile"
      when "passwords#new"
        "Forgot your password?"
      when "passwords#edit"
        "Change password!"
      when "sessions#new"
        "Login to Boarrd."
      else
        model_name = self.controller_name.classify

        model_name = "Boarrd" if model_name == "Dashboard"

        case action_name.to_sym
          when :new
            "Create a new #{model_name}!"
          when :edit
            "Edit #{model_name}"
          when :show
            "#{model_name} Details"
          when :index
            "Your #{model_name.pluralize}"
        end
    end
  end

end
