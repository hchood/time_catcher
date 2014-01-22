require 'spec_helper'

feature 'user edits an activity', %Q{
  As an authenticated user
  I want to edit an activity
  So that I can correct mistakes or change the amount of time needed for the activity
} do

  # Acceptance criteria:
  #    * I must be signed in to edit an activity
  #    * If I’m not signed in, I am not allowed access to edit an activity
  #    * From the '/activities' page, I must select an activity to edit.
  #    * I must select “save changes”.  Changes to the activity list will be saved.
  #    * If I modify an activity so that it has the same name as another activity in my
  # activity list, I receive an error message.
  #    * If I do not specify all require attributes, I receive an error message.

  context 'authenticated user' do
    before :each do
      @user = FactoryGirl.create(:user)
      @activity = FactoryGirl.create(:activity, user: @user)
      login(@user)
      click_on 'My Activities'
      click_on 'Edit'
    end

    scenario 'updates activity attributes' do
      fill_in 'activity_name', with: 'A Different Name'
      fill_in 'activity_time_needed_in_min', with: 20
      click_on 'Update Activity'

      # displays success message
      expect(page).to have_content 'Changes saved!'

      # activity attributes are updated
      expect(Activity.first.name).to eq 'A Different Name'
      expect(Activity.first.time_needed_in_min).to eq 20
    end

    scenario 'updates activity with missing attributes' do
      fill_in 'activity_name', with: ''
      click_on 'Update Activity'

      # displays error message
      expect(page).to have_content "can't be blank"

      # activity attributes are not updated
      expect(Activity.first.name).to eq @activity.name
    end

    scenario 'activity name already taken' do
      existing_activity = FactoryGirl.create(:activity, user: @user)

      fill_in 'activity_name', with: existing_activity.name
      click_on 'Update Activity'

      # displays error message
      expect(page).to have_content 'has already been taken'

      # activity attributes are not updated
      expect(Activity.first.name).to eq @activity.name
    end
  end

  context 'unauthenticated user' do
    scenario 'tries to edit an activity' do
      visit '/activities'

      expect(page).to have_content 'You need to sign in or sign up before continuing'
      expect(page).to_not have_link 'Edit'
    end
  end
end
