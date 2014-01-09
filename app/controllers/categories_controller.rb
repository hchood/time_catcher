class CategoriesController < ApplicationController
  before_action :authenticate_user!

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to new_category_path, notice: 'Category was successfully created.'
    else
      flash[:notice] = 'We encountered some errors.'
      render 'new'
    end
  end

  private

  def category_params
    params.require(:category).permit(:name).merge(user: current_user)
  end
end
