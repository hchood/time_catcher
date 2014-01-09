class ActivitySessionsController < ApplicationController
  before_action :authenticate_user!

  def new
    @activities = Activity.where(user: current_user)
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
    @activity_session = ActivitySession.new(activity_session_params)
    if @activity_session.save
      redirect_to edit_activity_session_path(@activity_session)
    else
      flash[:notice] = "Sorry, you don't have any activities you can do in #{self.time_available} minutes."
      redirect_to new_activity_session_path
    end
  end

  def time_available
    hash = params.require(:activity_session).permit(:time_available)
    hash['time_available']
  end

  private

  def activity_session_params
    params.require(:activity_session).permit(:time_available).merge(activity: @activity)
  end
end
