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

  let!(:user) { FactoryGirl.create(:user) }

  scenario 'adds an activity with valid attributes' do
    login(user)

    category = FactoryGirl.create(:category, user: user)
    activity = FactoryGirl.build(:activity, category: category)
    click_on 'Add Activity'
    fill_in 'Name', with: activity.name
    fill_in 'Description', with: activity.description
    fill_in 'Time Needed', with: activity.time_needed_in_min
    select activity.category_name, from: 'Category'
    click_button 'Create Activity'

    expect(page).to have_content 'Activity was successfully created.'
    expect(page).to have_button 'Create Activity'

    # saves category properly
    expect(Activity.first.category_name).to eq activity.category_name
  end

  scenario 'adds an activity without optional attributes' do
    login(user)

    activity = FactoryGirl.build(:activity)
    click_on 'Add Activity'
    fill_in 'Name', with: activity.name
    fill_in 'Time Needed', with: activity.time_needed_in_min
    click_button 'Create Activity'

    expect(page).to have_content 'Activity was successfully created.'
    expect(page).to have_button 'Create Activity'
  end

  scenario 'adds an activity without required attributes' do
    login(user)

    click_on 'Add Activity'
    click_on 'Create Activity'

    expect(page).to have_button 'Create Activity'

    within '.input.activity_name' do
      expect(page).to have_content "can't be blank"
    end

    within '.input.activity_time_needed_in_min' do
      expect(page).to have_content "can't be blank"
    end
  end

  scenario 'adds an activity already in the list' do
    login(user)
    existing_activity = FactoryGirl.create(:activity, user: user)
    new_activity = FactoryGirl.build(:activity, user: user, name: existing_activity.name)

    click_on 'Add Activity'
    fill_in 'Name', with: new_activity.name
    fill_in 'Description', with: new_activity.description
    fill_in 'Time Needed', with: new_activity.time_needed_in_min
    click_button 'Create Activity'

    expect(Activity.count).to eq 1
    expect(page).to have_content 'has already been taken'
    expect(page).to have_button 'Create Activity'
  end

  scenario 'unauthenticated user attempts to add an activity' do
    visit '/activities/new'

    expect(page).to have_content 'You need to sign in or sign up before continuing'
    expect(page).to_not have_button 'Create Activity'
  end
end
