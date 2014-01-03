require 'spec_helper'

feature 'Authenticated user adds an activity', %Q{
  As an authenticated user
  I want to add an activity
  So that the app can tell me to complete the activity when I use it
} do

  # Acceptance Criteria:
  #  * I must be signed in to add an activity
  #  * If I’m not signed in, I am not allowed access to add an activity
  #  * I must specify an activity name, estimated minimum time to complete the activity.
  #  * I can optionally specify a description
  #  * I can optionally specify a category
  #  * activity name must be unique
  #  * If I specify the required details, the activity is logged & I receive a friendly confirmation!
  #  * If I don’t, I’m presented with error messages
  #  * If the name of the activity I entered is already in my activity list, I receive an error message.

  scenario 'adds an activity with valid attributes' do
    user = FactoryGirl.create(:user)
    login(user)

    activity = FactoryGirl.build(:activity)
    click_on 'Add Activity'
    fill_in 'Name', with: activity.name
    fill_in 'Description', with: activity.description
    fill_in 'Time Needed', with: activity.time_needed_in_min
    select activity.category_name, from: 'Category'
    click_button 'Create Activity'

    expect(page).to have_content 'Activity was successfully created.'
    expect(page).to have_button 'Create Activity'
  end

  scenario 'adds an activity without required attributes'

  scenario 'adds an activity already in the list'

  scenario 'unauthenticated user attempts to add an activity'
end
