require 'spec_helper'

feature 'Authenticated user adds a category', %Q{
  As an authenticated user
  I want to add a category
  So that I can categorize my activities
} do

# Acceptance Criteria:
  # *  I must be signed in to add a category
  # *  If I'm not signed in, I am not allowed access to add a category
  # *  I must specify a category name
  # *  Category name must be unique
  # *  If I specify a valid name, the category is saved and I receive a friendly confirmation
  # and am redirected to add a new category
  # *  If I don't, I'm presented with error messages

  let!(:user) { FactoryGirl.create(:user) }

  scenario 'adds category with valid name' do
    login(user)

    category = FactoryGirl.build(:category)
    click_on 'Add Category'
    fill_in 'Name', with: category.name
    click_button 'Create Category'

    expect(Category.all.count).to eq 1
    expect(page).to have_content 'Category was successfully created.'
    expect(page).to have_button 'Create Category'
  end

end
