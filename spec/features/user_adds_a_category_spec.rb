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

  context 'authenticated user' do
    before :each do
      @user = FactoryGirl.create(:user)
      @category = FactoryGirl.build(:category)
      login(@user)
      click_on 'Add Category'
    end

    scenario 'adds category with valid name' do
      fill_in 'Name', with: @category.name
      click_button 'Create Category'

      expect(Category.count).to eq 1
      expect(page).to have_content 'Category was successfully created.'
      expect(page).to have_button 'Create Category'
    end

    scenario 'name is missing' do
      click_button 'Create Category'

      expect(Category.count).to eq 0
      expect(page).to have_content "Uh oh!  We encountered a problem."
      expect(page).to have_content "can't be blank"
      expect(page).to have_button 'Create Category'
    end

    scenario 'name is already taken' do
      existing_category = FactoryGirl.create(:category, user: @user)

      fill_in 'Name', with: existing_category.name
      click_button 'Create Category'

      expect(Category.count).to eq 1
      expect(page).to have_content "Uh oh!  We encountered a problem."
      expect(page).to have_content 'has already been taken'
      expect(page).to have_button 'Create Category'
    end
  end

  context 'unauthenticated user' do
    scenario 'tries to add a category' do
      visit '/categories/new'

      expect(page).to have_content 'You need to sign in or sign up before continuing'
      expect(page).to_not have_button 'Create Category'
    end
  end
end
