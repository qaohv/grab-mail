class WelcomeController < ApplicationController
  def index;end

  def dynamic_header
    render layout: false
  end
end
