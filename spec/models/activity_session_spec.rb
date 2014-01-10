require 'spec_helper'

describe ActivitySession do
  it { should validate_presence_of :activity_id }
  it { should validate_presence_of :time_available }
  it { should validate_numericality_of(:time_available).is_greater_than(0) }
  it { should have_valid(:time_available).when(1, 5) }
  it { should_not have_valid(:time_available).when('abd', 0) }

  it { should belong_to(:activity).dependent(:destroy) }
  it { should have_many(:activity_selections).dependent(:destroy) }
  it { should have_one(:user).through(:activity)}

  let!(:user)            { FactoryGirl.create(:user) }
  let!(:short_activity)  { FactoryGirl.create(:activity, user: user) }
  let!(:med_activity)    { FactoryGirl.create(:activity, user: user, time_needed_in_min: 10) }
  let!(:long_activity)   { FactoryGirl.create(:activity, user: user, time_needed_in_min: 15) }
  let!(:time_available)  { 10 }
  let!(:possible_choices){ ActivitySession.activities_doable_given(user, time_available) }


  describe '.activities_already_selected' do
    it 'returns an array of all activities than have been selected in the session' do
      activity_session = FactoryGirl.create(:activity_session, user: user, time_available: 15)
      activity_session.activity_selections << ActivitySelection.create(activity_session: activity_session, activity: short_activity)
      activity_session.activity_selections << ActivitySelection.create(activity_session: activity_session, activity: med_activity)

      expect(activity_session.activities_already_selected.length).to eq 2
      expect(activity_session.activities_already_selected).to include(short_activity)
      expect(activity_session.activities_already_selected).to include(med_activity)
      expect(activity_session.activities_already_selected).to_not include(long_activity)
    end
  end

  describe '.activities_doable_given' do
    context 'selects possible activities for first time in session' do
      it 'selects all activities that can be completed in the time available' do
        possible_activities = ActivitySession.activities_doable_given(user, time_available)

        expect(possible_activities.length).to eq 2
        expect(possible_activities).to include(short_activity)
        expect(possible_activities).to include(med_activity)
      end

      it "does not select other users' activities" do
        user2 = FactoryGirl.create(:user)
        user2_activity = FactoryGirl.create(:activity, user: user2)

        possible_activities = ActivitySession.activities_doable_given(user, time_available)
        expect(possible_activities.length).to eq 2
        expect(possible_activities).to_not include(user2_activity)
      end
    end

    context 'selects possible subsequent activities' do
      it 'only selects activities that have not yet been selected in a given activity_session' do
        activity_session = FactoryGirl.create(:activity_session, user: user, time_available: time_available, activity: short_activity)
        activity_session.activity_selections << ActivitySelection.create(activity_session: activity_session, activity: activity_session.activity)

        possible_activities = ActivitySession.activities_doable_given(activity_session.user, activity_session.time_available, activity_session)

        expect(possible_activities.length).to eq 1
        expect(possible_activities).to include(med_activity)
      end
    end
  end

  describe '.random_activity_for' do
    context 'selects the first activity in a session' do
      it 'selects a random activity that can be completed in the time available' do
        activity_chosen = ActivitySession.random_activity_for(user, time_available)

        expect(possible_choices).to include(activity_chosen)
        expect(activity_chosen).to_not eq long_activity
      end
    end

    context 'selects a subsequent activity' do
      it 'selects an activity that has not yet been selected' do
        activity_session = FactoryGirl.create(:activity_session, user: user, time_available: time_available, activity: short_activity)
        activity_session.activity_selections << ActivitySelection.create(activity_session: activity_session, activity: activity_session.activity)

        second_activity = ActivitySession.random_activity_for(activity_session.user, activity_session.time_available, activity_session)

        expect(second_activity).to eq med_activity
        expect(second_activity).to_not eq short_activity
      end
    end
  end
end
