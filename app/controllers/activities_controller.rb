class ActivitiesController < ApplicationController

  def index
    @user = current_user
    @activities = Activity.where(user: current_user)
  end

  def edit
    @activity = Activity.find(params[:id])
  end

  def update
    @activity = Activity.find(params[:id])
    if @activity.update(activity_params)
      redirect_to activities_path, notice: 'Changes saved!'
    else
    end
  end

  def new
    @activity = Activity.new
    @categories = Category.where(user: current_user)
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
    params.require(:activity).permit(:name, :description, :time_needed_in_min, :category_id).merge(user: current_user)
  end
end
