require 'spec_helper'

describe ActivitySession do
  it { should validate_presence_of :activity_id }
  it { should validate_presence_of :time_available }
  it { should validate_numericality_of(:time_available).is_greater_than(0) }

  it { should belong_to(:activity).dependent(:destroy) }

  let!(:user)            { FactoryGirl.create(:user) }
  let!(:short_activity)  { FactoryGirl.create(:activity, user: user) }
  let!(:med_activity)    { FactoryGirl.create(:activity, user: user, time_needed_in_min: 10) }
  let!(:long_activity)   { FactoryGirl.create(:activity, user: user, time_needed_in_min: 15) }

  describe '.random_activity_for' do
    it 'selects a random activity that can be completed in the time available' do
      time_available = 10

      possible_choices = [short_activity, med_activity]
      activity_chosen = ActivitySession.random_activity_for(time_available)

      expect(possible_choices).to include(activity_chosen)
      expect(activity_chosen).to_not eq long_activity
    end
  end

  describe '.activities_doable_in' do
    it 'selects all activities that can be completed in the time available' do
      time_available = 10

      possible_activities = ActivitySession.activities_doable_in(time_available)

      expect(possible_activities.length).to eq 2
      expect(possible_activities).to include(short_activity)
      expect(possible_activities).to include(med_activity)
    end
  end
end
