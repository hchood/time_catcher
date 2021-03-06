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

  context 'authenticated user' do
    let!(:user) { FactoryGirl.create(:user) }

    context 'who has activities' do
      before :each do
        @short_activity = FactoryGirl.create(:activity, user: user)
        @med_activity = FactoryGirl.create(:activity, user: user, time_needed_in_min: 10, description: 'A different activity')
        @long_activity = FactoryGirl.create(:activity, user: user, time_needed_in_min: 15, description: 'Activity is too long')
        login(user)
      end

      scenario 'provides valid time available and is given an activity' do
        fill_in 'activity_session[time_available]', with: 10
        click_on 'Give me something to do!'

        expect_page_to_have_one_of([@short_activity.name, @med_activity.name])
        expect_page_to_have_one_of([@short_activity.description, @med_activity.description])

        expect(page).to_not have_content @long_activity.name
        expect(page).to_not have_content @long_activity.description

        # correct buttons are displayed
        expect(page).to have_button "I'm done!"
        expect(page).to have_button 'Skip'

        # ActivitySession object is created
        expect(ActivitySession.count).to eq 1
        expect(ActivitySession.first.activity).to_not be_nil
      end

      context 'provides invalid time available' do
        scenario 'provides a string' do
          fill_in 'activity_session[time_available]', with: 'abc'
          click_on 'Give me something to do!'

          expect(page).to have_content 'You must enter a number greater than 0.'
          expect(page).to have_button 'Give me something to do!'

          expect(ActivitySession.count).to eq 0
        end

        scenario 'provides a negative number' do
          fill_in 'activity_session[time_available]', with: -5
          click_on 'Give me something to do!'

          expect(page).to have_content 'You must enter a number greater than 0.'
          expect(page).to have_button 'Give me something to do!'

          expect(ActivitySession.count).to eq 0
        end

        scenario 'provides 0' do
          fill_in 'activity_session[time_available]', with: 0
          click_on 'Give me something to do!'

          expect(page).to have_content 'You must enter a number greater than 0.'
          expect(page).to have_button 'Give me something to do!'

          expect(ActivitySession.count).to eq 0
        end

        scenario 'leaves time available blank' do
          click_on 'Give me something to do!'

          expect(page).to have_content 'You must enter a number greater than 0.'
          expect(page).to have_button 'Give me something to do!'

          expect(ActivitySession.count).to eq 0
        end
      end

      scenario 'has no activities that can be done in the time available' do
        fill_in 'activity_session[time_available]', with: 3
        click_button 'Give me something to do!'

        expect(page).to have_content "Sorry, you don't have any activities you can do in 3 minutes."
        expect(page).to have_link 'Add Activity'
      end
    end

    context 'who does not have activities' do
      scenario 'is not given an activity to do' do
        login(user)

        expect(page).to have_content "You haven't added any activities yet."
        expect(page).to have_link 'here'
      end
    end
  end

  context 'unauthenticated user' do
    scenario 'cannot get an activity' do
      visit '/activity_sessions/new'

      expect(page).to have_content 'You need to sign in or sign up before continuing'
      expect(page).to_not have_button "Let's go!"
    end
  end

  def expect_page_to_have_one_of(activity_attributes)
    found_count = 0

    activity_attributes.each do |activity_attribute|
      found_count += 1 if page.has_content?(activity_attribute)
    end
    expect(found_count).to eq 1
  end
end
