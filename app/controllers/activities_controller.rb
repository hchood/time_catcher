class ActivitiesController < ApplicationController
  before_action :authenticate_user!
  def new
    @activity = Activity.new
    @categories = Category.all
  end

  def create
    @activity = Activity.new(activity_params)
    if @activity.save
      redirect_to new_activity_path, notice: 'Activity was successfully created.'
    else
      render 'new', notice: 'We encountered some errors.'
    end
  end

  private

  def activity_params
    params.require(:activity).permit(:name, :description, :time_needed_in_min, :category).merge(user: current_user)
  end
end