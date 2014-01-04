class CategoriesController < ApplicationController
  def new
    @category = Category.new
  end

  def create
    @category = Category.new(params.require(:category).permit(:name))
    if @category.save
      redirect_to new_category_path, notice: 'Category was successfully created.'
    else
      flash[:notice] = 'We encountered some errors.'
      render 'new'
    end
  end
end