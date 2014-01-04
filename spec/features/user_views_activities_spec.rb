require 'spec_helper'

feature 'Authenticated user views list of activities', %Q{
  As an authenticated user
  I want to view a list of my activities
  So I can decide whether to add or delete any
} do

  # Acceptance Criteria:
  # * I must be signed in to view my activities
  # * If I’m not signed in, I am not allowed access to view my activities
  # * I can click a link from my home screen to view a list of activities, with name, description, category, and time needed displayed
  # * I can only view my own activities

  # after(:all) do
  #   Activity.delete_all
  #   Category.delete_all
  # end

  scenario 'authenticated user views activities' do
    user = FactoryGirl.create(:user)
    activity1 = FactoryGirl.create(:activity, user: user)
    activity2 = FactoryGirl.create(:activity, user: user)

    login(user)
    click_on 'My Activities'

    expect(page).to have_content activity1.name
    expect(page).to have_content activity2.name
    expect(page).to have_content activity1.category_name
    expect(page).to have_content activity2.category_name
    expect(page).to have_content activity1.description
    expect(page).to have_content activity1.time_needed_in_min
  end

  scenario 'unauthenticated user tries to view activities' do
    visit '/activities'

    expect(page).to have_content 'You need to sign in or sign up before continuing'
    expect(page).to_not have_button 'My Activities'
  end

  scenario 'user can only view own activities' do
    user = FactoryGirl.create(:user)
    activity = FactoryGirl.create(:activity, user: user)

    other_user = FactoryGirl.create(:user)
    other_activity = FactoryGirl.create(:activity, user: other_user)

    login(user)
    click_on 'My Activities'

    expect(page).to have_content activity.name
    expect(page).to_not have_content other_activity.name
  end
end
