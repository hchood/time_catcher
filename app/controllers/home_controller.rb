class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    redirect_to new_activity_session_path if current_user
  end
end
