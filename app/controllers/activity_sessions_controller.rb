class ActivitySessionsController < ApplicationController
  include ActionView::Helpers::TextHelper

  def index
    @activity_sessions = ActivitySession.where(user: current_user, finished_at: 7.days.ago..Time.now).order('start_time DESC')
  end

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
    @activity_session.activity.completed_count += 1
    @activity_session.activity.save
    if @activity_session.update(finished_at: Time.now)
      redirect_to new_activity_session_path, notice: "Yay!"
    else
      flash.now[:notice] = "Uh oh!  We encountered an error."
      render 'edit'
    end
  end

  def create
    @activity = ActivitySession.random_activity_for(current_user, time_available)
    @activity_session = ActivitySession.new(activity_session_params)
    if @activity_session.save
      redirect_to edit_activity_session_path(@activity_session)
    else
      if time_available > 0
        flash.now[:notice] = "Sorry, you don't have any activities you can do in #{pluralize(time_available, 'minute')}."
      else
        flash.now[:notice] = "You must enter a number greater than 0."
      end
      render new_activity_session_path
    end
  end

  def skip_activity
    @activity_session = ActivitySession.find(params[:id])
    @activity_session.activity.skipped_count += 1
    @activity_session.activity.save
    ActivitySelection.create(activity_session: @activity_session, activity: @activity_session.activity)
    new_activity = ActivitySession.random_activity_for(@activity_session.user, @activity_session.time_available, @activity_session)
    if new_activity.blank?
      flash[:notice] = "You're out of activities that can be done in #{pluralize(@activity_session.time_available, 'minute')}."
      redirect_to new_activity_session_path
    else
      @activity_session.activity = new_activity
      @activity_session.start_time = Time.new
      if @activity_session.save
        redirect_to edit_activity_session_path(@activity_session)
      else
        flash.now[:notice] = "Sorry, we encountered an error."
        redirect_to new_activity_session_path
      end
    end
  end

  def time_available
    hash = params.require(:activity_session).permit(:time_available)
    hash['time_available'].to_i
  end

  private

  def activity_session_params
    params.require(:activity_session).permit(:time_available).merge(activity: @activity, start_time: Time.new, user: current_user)
  end
end
