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

  let!(:user) { FactoryGirl.create(:user) }
  let!(:activity_sessions) do
    array = []
    2.times { array << FactoryGirl.create(:activity_session, user: user) }
    array
  end

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
      end

      it 'sorts by activity name'
      it 'sorts by category'
      it 'sorts by duration'
      it 'sorts by date'
    end

    context 'does not have activities logged' do
      it 'displays a message'
      it 'does not display activity log table'
    end
  end

  context 'unauthenticated user' do
    it 'does not allow access to acitvity log'
  end
end
