class HomeController < ApplicationController
  def index
    redirect_to new_activity_session_path if current_user
  end
end
