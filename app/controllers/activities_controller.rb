class ActivitiesController < ApplicationController

  def index
    @user = current_user
    @activities = Activity.where(user: current_user)
  end

  def edit
    @activity = Activity.find(params[:id])
    @category_names = Category.where(user: current_user).pluck(:name).to_s
  end

  def update
    category = Category.find_or_create_by(name: params[:activity][:category_string], user: current_user) unless params[:activity][:category_string].blank?
    @activity = Activity.find(params[:id])
    @activity.category = category
    if @activity.update(activity_params)
      redirect_to activities_path, notice: 'Changes saved!'
    else
      flash.now[:notice] = "Uh oh!  We encountered a problem."
      render 'edit'
    end
  end

  def new
    @activity = Activity.new
    @category_names = Category.where(user: current_user).pluck(:name).to_s
  end

  def create
    category = Category.find_or_create_by(name: params[:activity][:category_string], user: current_user) unless params[:activity][:category_string].blank?
    @activity = Activity.new(activity_params)
    @activity.category = category
    if @activity.save
      redirect_to new_activity_path, notice: 'Activity was successfully created.'
    else
      flash.now[:notice] = "Uh oh!  We encountered a problem."
      render 'new'
    end
  end

  def destroy
    @activity = Activity.find(params[:id])
    if @activity.destroy
      redirect_to activities_path, notice: 'Activity has been deleted.'
    else
      flash.now[:notice] = "Uh oh!  We encountered a problem."
      redirect_to activities_path
    end
  end

  private

  def activity_params
    params.require(:activity).permit(:name, :description, :time_needed_in_min, :category_string).merge(user: current_user)
  end
end
