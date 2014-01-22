require 'spec_helper'

feature 'user deletes a category', %Q{
  As an authenticated user
  I want to delete a category
  So that I can dis-associate activities from that category
} do

  # Acceptance criteria:
  #    * I must be signed in to delete a category
  #    * If I’m not signed in, I am not allowed access to delete a category
  #    * From the categories screen, I must click "Delete" next to the appropriate category

  let!(:user)     { FactoryGirl.create(:user) }
  let!(:category) { FactoryGirl.create(:category, user: user) }

  context 'authenticated user' do
    scenario 'deletes category' do
      login(user)
      click_on 'My Categories'
      click_on 'Delete'

      # displays success message
      expect(page).to have_content 'Category has been deleted.'

      # does not display
      expect(page).to_not have_content category.name
    end
  end

  context 'unauthenticated user' do
    scenario 'tries to delete a category' do
      visit '/categories'

      expect(page).to have_content 'You need to sign in or sign up before continuing'
      expect(page).to_not have_link 'Edit'
      expect(page).to_not have_link 'Delete'
    end
  end
end
