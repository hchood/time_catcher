class CategoriesController < ApplicationController
  def new
    @category = Category.new
  end

  def create
    @category = Category.new(params.require(:category).permit(:name))
    if @category.save
      redirect_to new_category_path, notice: 'Category was successfully created.'
    else
      render 'new', notice: 'We encountered some errors.'
    end
  end
end
