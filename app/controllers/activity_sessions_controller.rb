class ActivitySessionsController < ApplicationController
  # def index
  #   @activity_session = ActivitySession.new
  # end
  before_action :authenticate_user!

  def new
    @activity_session = ActivitySession.new
  end

  def edit
    @activity_session = ActivitySession.find(params[:id])
    @activity = @activity_session.activity
  end

  def update
    @activity_session = ActivitySession.find(params[:id])
    if @activity_session.update(activity_session_params)
      redirect_to users_home_index, notice: "Yay!"
    else
      flash[:notice] = "Error!"
      render 'edit'
    end
  end

  def create
    @activity = ActivitySession.random_activity_for(time_available)
    @activity_session = ActivitySession.new({time_available: time_available, activity_id: @activity.id})
    if @activity_session.save
      redirect_to edit_activity_session_path(@activity_session)
    else
      render 'users/home#index'
    end
  end

  private

  def time_available
    hash = params.require(:activity_session).permit(:time_available)
    hash['time_available']
  end

  def activity_session_params
    { time_available: time_available, activity_id: @activity.id, duration_in_seconds: @activity_session.set_duration }
  end
end
