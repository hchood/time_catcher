require 'spec_helper'

feature 'user edits a category', %Q{
  As an authenticated user
  I want to edit a category
  So that I can correct misspellings or give it a better name
} do

  # Acceptance criteria:
  #    * I must be signed in to edit a category
  #    * If I’m not signed in, I am not allowed access to edit a category
  #    * From the categories screen, I must select a category to edit.
  #    * I must select “save changes”.  Changes to the category will be saved.
  #    * If I modify a category so that it has the same name as another
  # category in my list, I receive an error message.

  context 'authenticated user' do
    before :each do
      @user = FactoryGirl.create(:user)
      @category = FactoryGirl.create(:category, user: @user)
      login(@user)
      click_on 'My Categories'
      click_on 'Edit'
    end

    scenario 'updates category' do
      fill_in 'Name', with: 'A Different Name'
      click_on 'Update Category'

      # displays success message
      expect(page).to have_content 'Changes saved!'

      # category attributes are updated
      expect(Category.first.name).to eq 'A Different Name'
    end

    scenario 'updates category with missing name attribute' do
      fill_in 'Name', with: nil
      click_on 'Update Category'

      # displays error message
      expect(page).to have_content "can't be blank"

      # category name is not updated
      expect(Category.first.name).to eq @category.name
    end

    scenario 'category name already taken' do
      existing_category = FactoryGirl.create(:category, user: @user)

      fill_in 'Name', with: existing_category.name
      click_on 'Update Category'

      # displays error message
      expect(page).to have_content 'has already been taken'

      # category name is not updated
      expect(Category.first.name).to eq @category.name
    end
  end

  context 'unauthenticated user' do
    scenario 'tries to edit a category' do
      visit '/categories'

      expect(page).to have_content 'You need to sign in or sign up before continuing'
      expect(page).to_not have_link 'Edit'
    end
  end

end
