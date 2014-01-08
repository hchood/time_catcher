class ActivitySessionsController < ApplicationController
  # def index
  #   @activity_session = ActivitySession.new
  # end

  def new
    @activity_session = ActivitySession.new
  end

  def create
    @activity = ActivitySession.random_activity_for(time_available)
    @activity_session = ActivitySession.new({time_available: time_available, activity_id: @activity.id})
    if @activity_session.save
      redirect_to edit_activity_session_path
    else
      render 'users/home#index'
    end
  end

  private

  def time_available
    hash = params.require(:activity_session).permit(:time_available)
    hash['time_available']
  end
end
