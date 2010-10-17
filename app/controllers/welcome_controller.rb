class WelcomeController < ApplicationController
  layout "welcome"
  def index
    @title = "Ahoy, Boarrd!"
  end
end