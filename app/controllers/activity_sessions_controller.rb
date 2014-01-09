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
      # i want to do different things here depending on the reason the session failed to save
      #  - if it couldn't find an activity that is doable in that time, redirect_to new path and give
      # appropriate error message
      #  - if user entered an invalid amount of time, I want to render the page again and display and
      # appropriate error message.  However, if I render the page, it for some reason thinks that
      # the user doesn't have any activities at all.  ???

      if self.time_available <= 0
        flash[:notice] = 'You must enter a number greater than zero.'
      else
        flash[:notice] = "Sorry, you don't have any activities you can do in #{self.time_available} minutes."
      end
      redirect_to new_activity_session_path
    end
  end

  def time_available
    hash = params.require(:activity_session).permit(:time_available)
    hash['time_available'].to_i
  end

  private

  def activity_session_params
    params.require(:activity_session).permit(:time_available).merge(activity: @activity)
  end
end
