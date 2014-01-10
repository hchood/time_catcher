require 'spec_helper'

feature 'Authenticated user skips an activity', %Q{
  As an authenticated user that is doing activities
  I want to be given a different activity
  So that I can skip the activity I was initially given & move on to a different one
} do

  # Acceptance criteria:
  # * I must be signed in to skip an activity
  # * If I’m not signed in, I am not allowed access to skip an activity.
  # * I must have just asked for an activity to do and been presented with one.
  # * After I have been given an activity, I must select the “skip activity” option.
  # * I am given a different activity from my activity list that has a “minimum estimated time”
  # that is less than or equal to the amount of time I entered initially.
  #  * If I have been given all the activities on my list in that given session, I receive an error message.


  let!(:user)           { FactoryGirl.create(:user) }
  let!(:short_activity) { FactoryGirl.create(:activity, user: user) }
  let!(:med_activity)   { FactoryGirl.create(:activity, user: user, time_needed_in_min: 10, description: 'A different activity') }
  let!(:long_activity)  { FactoryGirl.create(:activity, user: user, time_needed_in_min: 15, description: 'Activity is too long') }

  before(:each) do
    login(user)
    fill_in 'activity_session[time_available]', with: 10

    click_on 'Give me something to do!'
    @activity_session = ActivitySession.first
    @first_activity = @activity_session.activity
    @first_start_time = @activity_session.start_time

    click_on 'Skip'
    @second_activity = @activity_session.reload.activity
    @second_start_time = @activity_session.start_time
  end

  scenario 'user skips the first activity' do
    expect(page).to have_content @second_activity.name
    expect(page).to have_content @second_activity.description

    expect(page).to_not have_content @first_activity.name
    expect(page).to_not have_content long_activity.name

    # correct buttons are displayed
    expect(page).to have_button "I'm done!"
    expect(page).to have_button 'Skip'

    # ActivitySession object is updated:  first activity is added to activity_selections
    expect(@activity_session.activities_already_selected.length).to eq 1
    expect(@first_start_time).to_not eq @second_start_time
  end

  scenario 'user has no more activities that can be done in the time available' do
    click_on 'Skip'

    possible_activities = ActivitySession.activities_doable_given(@activity_session.user, @activity_session.time_available, @activity_session)

    expect(possible_activities).to be_empty
    expect(page).to have_content "You're out of activities that can be done in #{@activity_session.time_available} minutes."
    expect(page).to have_button 'Give me something to do!'
  end
end
