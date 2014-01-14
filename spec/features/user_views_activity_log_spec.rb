require 'spec_helper'

feature 'authenticated user views activity log', %Q{
  As an authenticated user
  I want to view my activity log after I log in
  So that I can see activities that I’ve completed
} do

  # Acceptance criteria:
  #    * I must be signed in to view my activity log
  #    * If I’m not signed in, I am not allowed access to view my activity log.
  #    * From my home screen, I must select the "view activity log" option.
  #    * I am presented with a log of my activities in the last week, including the date, the name of
  # the activity, the category, and the time spent doing it.
  #    * I can sort my activity log by any of the fields in the table
  #    * If I have not done any activities in the past week, I am presented with a message to that effect.

  let!(:user)               { FactoryGirl.create(:user) }
  let!(:activity_session1)  { FactoryGirl.create(:activity_session, user: user, start_time: 1.hour.ago, duration_in_seconds: 400) }
  let!(:activity_session2)  { FactoryGirl.create(:activity_session, user: user, start_time: 15.minutes.ago, duration_in_seconds: 250) }
  let!(:activity_sessions)  { [activity_session1, activity_session2] }

  context 'authenticated user' do
    before(:each) do
      login(user)
      click_on 'My Activity Log'
    end

    context 'has activities logged' do
      # before(:all) do
      #   activity_sessions = []
      #   2.times do
      #     activity_sessions << FactoryGirl.create(:activity_session, user: user)
      #   end
      # end

      it 'displays activities sorted by date' do
        activity_sessions.each do |session|
          expect(page).to have_content session.start_time
          expect(page).to have_content session.activity.name
          expect(page).to have_content session.activity.category_name
          expect(page).to have_content (session.duration_in_seconds / 60).to_i
        end

        activity_session2.activity.name.should appear_before(activity_session1.activity.name)
      end

      it 'sorts by activity name' do
        find('.activity-name').click
        activity_session1.activity.name.should appear_before(activity_session2.activity.name)
      end

      it 'sorts by category' do
        find('.category').click
        activity_session1.activity.name.should appear_before(activity_session2.activity.name)
      end

# BROKEN!!! But i think the ones above are, too -- they just happen to be in the right order
      it 'sorts by duration' do
        find('.duration').click
        # save_screenshot('/spec/test_screenshot.png', full: true)
        activity_session2.activity.name.should appear_before(activity_session1.activity.name)
      end

      it 'sorts by date' do
        find('.duration').click # change order
        find('.date').click # change order back to ordered by date
        activity_session2.activity.name.should appear_before(activity_session1.activity.name)
      end
    end

    context 'does not have activities logged' do
      it 'displays a message'
      it 'does not display activity log table'
    end
  end

  context 'unauthenticated user' do
    it 'does not allow access to acitvity log' do
      visit '/activity_sessions'

      expect(page).to have_content
    end
  end
end
