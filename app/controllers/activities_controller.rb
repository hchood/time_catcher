class ActivitiesController < ApplicationController
  def new
    @activity = Activity.new
    @categories = Category.all
  end
end
