require 'spec_helper'

feature 'User marks an activity completed', %Q{
  As an authenticated user that is doing activities
  I want to mark an activity “Complete” when I have finished it
  So that the app can log my activity
} do

  # Acceptance criteria:
  #    * I must be signed in to mark an activity complete
  #    * If I’m not signed in, I am not allowed access to mark an activity complete
  #    * I must have just asked for an activity to do and been presented with one.
  #    * When I have finished an activity, I want to select “Complete”
  #    * The activity will be marked complete

  scenario 'user marks activity complete' do
    user = FactoryGirl.create(:user)
    activity = FactoryGirl.create(:activity, user: user)
    login(user)

    fill_in 'activity_session[time_available]', with: 15
    click_on 'Give me something to do!'
    click_on "I'm done!"

    # number of times completed is incremented
    expect(activity.reload.completed_count).to eq 1

    # ActivitySession finished_at should be updated
    expect(ActivitySession.first.finished_at).to_not be_nil

    # redirects to new_activity_session_path
    expect(page).to have_button 'Give me something to do!'
  end
end
