require 'spec_helper'

feature 'Authenticated user gets an activity', %Q{
  As an authenticated user
  I want to be given an activity to do
  So that I can complete the activity
} do

  # Acceptance criteria:
  #    * I must be signed in to be given an activity to do
  #    * If I’m not signed in, I am not allowed access to get an activity
  #    * From my home screen, I must select the option to start doing activities.
  #    * I must have at least one activity in my activity list.  Otherwise, I receive an error message.
  #    * I am prompted to enter the amount of time I have.
  #    * I must enter the amount of time I have.
  #    * If I do not enter a valid time, I receive an error message and must re-enter a valid time.
  #    * I am presented with an activity from my activity list that has a “minimum estimated time” that is less than or equal to the amount of time I entered.
  #   * If there are no activities in my list under that time limit, I receive an error message and a link to "Add Activities" is displayed.

  let!(:user) { FactoryGirl.create(:user) }

  scenario 'user provides valid time available and is given an activity' do
    short_activity = FactoryGirl.create(:activity, user: user)
    med_activity = FactoryGirl.create(:activity, user: user, time_needed_in_min: 10, description: 'A different activity')
    long_activity = FactoryGirl.create(:activity, user: user, time_needed_in_min: 15, description: 'Activity is too long')

    login(user)
    fill_in 'activity_session[time_available]', with: 10
    click_on "Give me something to do!"

    expect_page_to_have_one_of([short_activity.name, med_activity.name])
    expect_page_to_have_one_of([short_activity.description, med_activity.description])

    expect(page).to_not have_content long_activity.name
    expect(page).to_not have_content long_activity.description

    expect(page).to have_link "I'm done!"
    expect(page).to have_link 'Skip'
  end

  scenario 'unauthenticated user cannot get an activity' do
    visit '/activity_sessions/new'

    expect(page).to have_content 'You need to sign in or sign up before continuing'
    expect(page).to_not have_button "Let's go!"
  end

  scenario 'user has no activities' do
    login(user)
    click_on "Give me something to do!"

    expect(page).to have_content "Sorry, you haven't added any activities yet."
    expect(page).to have_link 'Add Activity'
  end

  scenario 'user has no activities that can be done in the time available' do
    short_activity = FactoryGirl.create(:activity, user: user)
    med_activity = FactoryGirl.create(:activity, user: user, time_needed_in_min: 10)

    login(user)
    click_on "Give me something to do!"

    fill_in 'activity_session[time_available]', with: 3
    click_button "Let's go!"

    expect(page).to have_content "Sorry, you don't have any activities you can do in #{@time_available} minutes."
    expect(page).to have_link 'Add Activity'
  end

  scenario 'user enters an invalid time'

  scenario 'user does not enter a time'

  def expect_page_to_have_one_of(activity_attributes)
    found_count = 0

    activity_attributes.each do |activity_attribute|
      found_count += 1 if page.has_content?(activity_attribute)
    end
    expect(found_count).to eq 1
  end
end
