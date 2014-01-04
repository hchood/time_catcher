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
    2.times { FactoryGirl.create(:activity, user: user) }

    login(user)
    click_on 'My Activities'

    expect(page).to have_content 'Activity 1'
    expect(page).to have_content 'Activity 2'
    expect(page).to have_content 'Category 1'
    expect(page).to have_content 'Category 2'
    expect(page).to have_content 'This is a generic activity.'
    expect(page).to have_content '5'
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

    expect(page).to have_content 'Activity 3'
    expect(page).to_not have_content 'Activity 4'
  end
end
