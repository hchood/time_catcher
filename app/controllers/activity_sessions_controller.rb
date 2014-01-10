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
    @activity = ActivitySession.random_activity_for(current_user, time_available)
    @activity_session = ActivitySession.new(activity_session_params)
    if @activity_session.save
      redirect_to edit_activity_session_path(@activity_session)
    else
      flash[:notice] = "Sorry, you don't have any activities you can do in #{time_available} minutes." if @activity.blank?
      render new_activity_session_path
    end
  end


  def skip_activity
    @activity_session = ActivitySession.find(params[:id])
    ActivitySelection.create(activity_session: @activity_session, activity: @activity_session.activity)
    new_activity = nil # random activity where (1) doable in time_available; (2) not in activities_selected
    if new_activity.blank?
      flash[:notice] = "You have no more activities that can be done in #{@activity_session.time_available} minutes."
      redirect_to new_activity_session_path
    else
      @activity_session.activity = new_activity
      if @activity.save
        redirect_to edit_activity_session_path(@activity_session)
      else
        flash[:notice] = "ERROR!!!!!"
      end
    end
  end




  def time_available
    hash = params.require(:activity_session).permit(:time_available)
    hash['time_available'].to_i
  end

  private

  def activity_session_params
    binding.pry
    params.require(:activity_session).permit(:time_available).merge(activity: @activity)
  end
end
