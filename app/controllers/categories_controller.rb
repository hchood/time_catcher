class CategoriesController < ApplicationController

  def index
    @categories = Category.where(user: current_user)
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])
    if @category.update(category_params)
       redirect_to categories_path, notice: 'Changes saved!'
    else
      flash.now[:notice] = "Uh oh!  We encountered a problem."
      render 'edit'
    end
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to new_category_path, notice: 'Category was successfully created.'
    else
      flash.now[:notice] = "Uh oh!  We encountered a problem."
      render 'new'
    end
  end

  def destroy
    @category = Category.find(params[:id])
    if @category.destroy
      redirect_to categories_path, notice: 'Category has been deleted.'
    else
      flash.now[:notice] = "Uh oh!  We encountered a problem."
      redirect_to categories_path
    end
  end

  private

  def category_params
    params.require(:category).permit(:name).merge(user: current_user)
  end
end
