require 'spec_helper'

feature 'user deletes an activity', %Q{
  As an authenticated user
  I want to delete an activity
  So that I am no longer prompted to complete it
} do

  # Acceptance criteria:
  #    * I must be signed in to delete an activity
  #    * If I’m not signed in, I am not allowed access to delete an activity
  #    * If I’m not signed in, I am not allowed access to delete an activity
  #    * From the '/activities' page, I must select an activity to delete.

  let!(:user)     { FactoryGirl.create(:user) }
  let!(:activity) { FactoryGirl.create(:activity, user: user) }

  context 'authenticated user' do
    scenario 'deletes activity' do
      login(user)
      click_on 'My Activities'
      click_on 'Delete'

      # displays success message
      expect(page).to have_content 'Activity has been deleted.'

      # does not display
      expect(page).to_not have_content activity.name
    end
  end

  context 'unauthenticated user' do
    scenario 'tries to delete an activity' do
      visit '/activities'

      expect(page).to have_content 'You need to sign in or sign up before continuing'
      expect(page).to_not have_link 'Delete'
    end
  end
end
